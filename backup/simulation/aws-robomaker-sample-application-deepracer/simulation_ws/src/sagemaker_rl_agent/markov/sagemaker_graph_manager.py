from rl_coach.agents.clipped_ppo_agent import ClippedPPOAgentParameters
from rl_coach.base_parameters import VisualizationParameters, PresetValidationParameters, DistributedCoachSynchronizationType
from rl_coach.core_types import TrainingSteps, EnvironmentEpisodes, EnvironmentSteps
from rl_coach.environments.gym_environment import GymVectorEnvironment
from rl_coach.exploration_policies.categorical import CategoricalParameters
from rl_coach.exploration_policies.e_greedy import EGreedyParameters
from rl_coach.filters.filter import InputFilter
from rl_coach.filters.observation.observation_rgb_to_y_filter import ObservationRGBToYFilter
from rl_coach.filters.observation.observation_stacking_filter import ObservationStackingFilter
from rl_coach.filters.observation.observation_to_uint8_filter import ObservationToUInt8Filter
from rl_coach.graph_managers.basic_rl_graph_manager import BasicRLGraphManager
from rl_coach.graph_managers.graph_manager import ScheduleParameters
from rl_coach.schedules import LinearSchedule

from rl_coach.architectures.middleware_parameters import FCMiddlewareParameters, LSTMMiddlewareParameters
from rl_coach.architectures.embedder_parameters import InputEmbedderParameters


import tensorflow as tf
from rl_coach.architectures import layers
from rl_coach.architectures.tensorflow_components.layers import Conv2d, Dense
from rl_coach.architectures.tensorflow_components import utils


from markov.utils import Logger

import sys
import logging
logger = logging.getLogger(__name__) 
handler = logging.FileHandler('/tmp/deepracer.py.log')
logger.addHandler(handler)

def handle_exception(exc_type, exc_value, exc_traceback):
    if issubclass(exc_type, KeyboardInterrupt):
        sys.__excepthook__(exc_type, exc_value, exc_traceback)
        return

    logger.error("Uncaught exception", exc_info=(exc_type, exc_value, exc_traceback))

sys.excepthook = handle_exception

import json

import tensorflow as tf
import tensorflow.contrib as tf_contrib

def conv(x, channels, kernel=4, stride=2, padding='SAME', use_bias=True, scope='conv_0'):
    with tf.variable_scope(scope):
        x = tf.layers.conv2d(inputs=x, filters=channels,
                             kernel_size=kernel, #kernel_initializer=weight_init,
                             #kernel_regularizer=weight_regularizer,
                             strides=stride, use_bias=use_bias, padding=padding)

        return x

def resblock(x_init, channels, is_training=True, use_bias=True, downsample=False, scope='resblock'):
    with tf.variable_scope(scope) :

        x = batch_norm(x_init, is_training, scope='batch_norm_0')
        x = relu(x)


        if downsample :
            x = conv(x, channels, kernel=3, stride=2, use_bias=use_bias, scope='conv_0')
            x_init = conv(x_init, channels, kernel=1, stride=2, use_bias=use_bias, scope='conv_init')

        else :
            x = conv(x, channels, kernel=3, stride=1, use_bias=use_bias, scope='conv_0')

        x = batch_norm(x, is_training, scope='batch_norm_1')
        x = relu(x)
        x = conv(x, channels, kernel=3, stride=1, use_bias=use_bias, scope='conv_1')

        return x + x_init
    
def flatten(x):
    return tf.layers.flatten(x)

def global_avg_pooling(x):
    gap = tf.reduce_mean(x, axis=[1, 2], keepdims=True)
    return gap

def avg_pooling(x):
    return tf.layers.average_pooling2d(x, pool_size=2, strides=2, padding='SAME')

def batch_norm(x, is_training=True, scope='batch_norm'):
    return tf_contrib.layers.batch_norm(x,
                                        decay=0.9, epsilon=1e-05,
                                        center=True, scale=True, updates_collections=None,
                                        is_training=is_training, scope=scope)
def relu(x):
    return tf.nn.relu(x)

class Residual(object):
    def __init__(self, channels=32, downsample=False, scope='resblock'):
        self.channels = channels
        self.downsample = downsample
        self.scope = scope
    
    def __call__(self, input_layer, name: str=None, is_training=None):
        return resblock(input_layer, self.channels, is_training=is_training, downsample=self.downsample, scope=name)


class MaxPooling2d(object):
    def __init__(self, pool_size: int=2, stride: int=2):
        self.pool_size = pool_size
        self.stride = stride

    def __call__(self, input_layer, name: str=None, is_training=None):
        """
        returns a tensorflow max_pool layer
        :param input_layer: previous layer
        :param name: layer name
        :return: max_pool layer
        """
        
        return tf.nn.max_pool(input_layer, ksize=[1, self.pool_size, self.pool_size, 1], strides=[1, self.stride, self.stride, 1], padding='SAME', name=name)
    
    def __str__(self):
        return "Maxpool layer"

class Conv2dWithAttention(object):
    def __init__(self, num_filters: int, kernel_size: int, strides: int, units: int, reduce = False):
        self.num_filters = num_filters
        self.kernel_size = kernel_size
        self.strides = strides
        self.units = units
        self.reduce = reduce

    def __call__(self, input_layer, name: str=None, is_training=None):
        conv = tf.layers.conv2d(input_layer, filters=self.num_filters, kernel_size=self.kernel_size,strides=self.strides, data_format='channels_last', name=name)
        W1 = Dense(self.units)
        V = Dense(1)
        score = tf.nn.tanh(W1(conv)) 
        attention_weights = tf.nn.softmax(V(score), axis=1)
        context_vector = attention_weights * conv 
        if self.reduce:
            context_vector = tf.reduce_sum(context_vector, axis=1)
        return context_vector
    
# EVAL
def get_graph_manager(**hp_dict):
    ####################
    # All Default Parameters #
    ####################
    params = {}
    params["batch_size"] = int(hp_dict.get("batch_size", 64))
    params["num_epochs"] = int(hp_dict.get("num_epochs", 10))
    params["stack_size"] = int(hp_dict.get("stack_size", 1))
    params["lr"] = float(hp_dict.get("lr", 0.0003))
    params["exploration_type"] = (hp_dict.get("exploration_type", "categorical")).lower()
    params["e_greedy_value"] = float(hp_dict.get("e_greedy_value", .05))
    params["epsilon_steps"] = int(hp_dict.get("epsilon_steps", 10000))
    params["beta_entropy"] = float(hp_dict.get("beta_entropy", .01))
    params["discount_factor"] = float(hp_dict.get("discount_factor", .999))
    params["loss_type"] = hp_dict.get("loss_type", "Mean squared error").lower()
    params["num_episodes_between_training"] = int(hp_dict.get("num_episodes_between_training", 20))
    params["term_cond_max_episodes"] = int(hp_dict.get("term_cond_max_episodes", 100000))
    params["term_cond_avg_score"] = float(hp_dict.get("term_cond_avg_score", 100000))

    params_json = json.dumps(params, indent=2, sort_keys=True)
    print("Using the following hyper-parameters", params_json, sep='\n')

    ####################
    # Graph Scheduling #
    ####################
    schedule_params = ScheduleParameters()
    schedule_params.improve_steps = TrainingSteps(params["term_cond_max_episodes"])
    schedule_params.steps_between_evaluation_periods = EnvironmentEpisodes(40)
    schedule_params.evaluation_steps = EnvironmentEpisodes(5)
    schedule_params.heatup_steps = EnvironmentSteps(0)

    #########
    # Agent #
    #########
    agent_params = ClippedPPOAgentParameters()
    
    from rl_coach.architectures.middleware_parameters import FCMiddlewareParameters
    from rl_coach.architectures.embedder_parameters import InputEmbedderParameters
    from rl_coach.architectures.layers import Conv2d, Dense

#    agent_params.network_wrappers['main'].input_embedders_parameters = {
#            'observation': InputEmbedderParameters(
#                scheme=[
#                    Conv2d(32, 5, 2),
#                    Conv2d(32, 3, 1),
#                    Conv2d(64, 3, 2),
#                    Conv2d(64, 3, 1),
#                    Conv2d(128, 3, 2),
#                    Conv2d(128, 3, 1),
#                    Conv2d(256, 3, 2),
#                    Conv2d(256, 3, 1)
#                ],
#                activation_function='relu', dropout_rate=0.3)}
#    agent_params.network_wrappers['main'].middleware_parameters = FCMiddlewareParameters(
#                scheme=[
#                    Dense(128),
#                    Dense(128),
#                    Dense(128)
#                ],
#                activation_function='relu', dropout_rate=0.3
#            )

    agent_params.network_wrappers['main'].input_embedders_parameters = {
            'observation': InputEmbedderParameters(
                scheme=[
#                    Conv2d(32, 5, 2),
#                    Conv2d(32, 3, 1),
#                    Conv2d(64, 3, 2),
#                    Conv2d(64, 3, 1),
#                    Conv2d(128, 3, 2),
#                    Conv2d(128, 3, 1),
#                    Conv2d(256, 3, 2),
#                    Conv2d(256, 3, 1)
                    
#                    Conv2d(32, 5, 2),
#                    Residual(32),
#                    Residual(64, True),
#                    Residual(128, True),
#                    Conv2dWithAttention(128, 3, 1, 256, True),
                    #Conv2d(64, 3, 2),
                    #Residual(64),
                    #Conv2dWithAttention(64, 3, 1, 256, True),
                    #Conv2d(128, 3, 2),
                    #Residual(128),
                    #Conv2dWithAttention(128, 3, 1, 256),
                    #Conv2d(256, 3, 2),
                    #Residual(256),
                    #Conv2dWithAttention(256, 3, 1, 256, True)
                    Conv2d(32, 8, 4),
                    Conv2d(64, 4, 2),
                    Conv2dWithAttention(64, 3, 1, 256)
                ],
                activation_function='relu', dropout_rate=0.3)}

    agent_params.network_wrappers['main'].middleware_parameters = FCMiddlewareParameters(
                scheme=[
                    #Dense(256),
                    Dense(512),
                    Dense(512)
                    #Dense(32),
                    #Dense(32),
                    #Dense(64),
                    #Dense(64),
                    #Dense(64)
 #                   Dense(4096)
               ],
                activation_function='relu', dropout_rate=0.3
            )

    agent_params.network_wrappers['main'].learning_rate = params["lr"]
    agent_params.network_wrappers['main'].batch_size = params["batch_size"]
    agent_params.network_wrappers['main'].optimizer_epsilon = 1e-5
    agent_params.network_wrappers['main'].adam_optimizer_beta2 = 0.999

    if params["loss_type"] == "huber":
        agent_params.network_wrappers['main'].replace_mse_with_huber_loss = True

    agent_params.algorithm.clip_likelihood_ratio_using_epsilon = 0.2
    agent_params.algorithm.clipping_decay_schedule = LinearSchedule(1.0, 0, 1000000)
    agent_params.algorithm.beta_entropy = params["beta_entropy"]
    agent_params.algorithm.gae_lambda = 0.95
    agent_params.algorithm.discount = params["discount_factor"]
    agent_params.algorithm.optimization_epochs = params["num_epochs"]
    agent_params.algorithm.estimate_state_value_using_gae = True
    agent_params.algorithm.num_steps_between_copying_online_weights_to_target = EnvironmentEpisodes(
        params["num_episodes_between_training"])
    agent_params.algorithm.num_consecutive_playing_steps = EnvironmentEpisodes(params["num_episodes_between_training"])

    agent_params.algorithm.distributed_coach_synchronization_type = DistributedCoachSynchronizationType.SYNC

    if params["exploration_type"] == "categorical":
        agent_params.exploration = CategoricalParameters()
    else:
        agent_params.exploration = EGreedyParameters()
        agent_params.exploration.epsilon_schedule = LinearSchedule(1.0,
                                                                   params["e_greedy_value"],
                                                                   params["epsilon_steps"])

    ###############
    # Environment #
    ###############
    DeepRacerInputFilter = InputFilter(is_a_reference_filter=True)
    DeepRacerInputFilter.add_observation_filter('observation', 'to_grayscale', ObservationRGBToYFilter())
    DeepRacerInputFilter.add_observation_filter('observation', 'to_uint8', ObservationToUInt8Filter(0, 255))
    DeepRacerInputFilter.add_observation_filter('observation', 'stacking',
                                                  ObservationStackingFilter(params["stack_size"]))

    env_params = GymVectorEnvironment()
    env_params.default_input_filter = DeepRacerInputFilter
    env_params.level = 'DeepRacerRacetrackCustomActionSpaceEnv-v0'

    vis_params = VisualizationParameters()
    vis_params.dump_mp4 = False

    ########
    # Test #
    ########
    preset_validation_params = PresetValidationParameters()
    preset_validation_params.test = True
    preset_validation_params.min_reward_threshold = 400
    preset_validation_params.max_episodes_to_achieve_reward = 10000

    graph_manager = BasicRLGraphManager(agent_params=agent_params, env_params=env_params,
                                        schedule_params=schedule_params, vis_params=vis_params,
                                        preset_validation_params=preset_validation_params)
    return graph_manager, params_json
