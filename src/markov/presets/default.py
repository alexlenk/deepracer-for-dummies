from rl_coach.architectures.layers import Conv2d, Dense, BatchnormActivationDropout
from rl_coach.architectures.middleware_parameters import FCMiddlewareParameters


from rl_coach.agents.clipped_ppo_agent import ClippedPPOAgentParameters
from rl_coach.base_parameters import VisualizationParameters, PresetValidationParameters
from rl_coach.core_types import TrainingSteps, EnvironmentEpisodes, EnvironmentSteps
from rl_coach.environments.gym_environment import GymVectorEnvironment
from rl_coach.exploration_policies.categorical import CategoricalParameters
from rl_coach.filters.filter import InputFilter
from rl_coach.filters.observation.observation_rgb_to_y_filter import ObservationRGBToYFilter
from rl_coach.filters.observation.observation_stacking_filter import ObservationStackingFilter
from rl_coach.filters.observation.observation_to_uint8_filter import ObservationToUInt8Filter
from rl_coach.graph_managers.basic_rl_graph_manager import BasicRLGraphManager
from rl_coach.graph_managers.graph_manager import ScheduleParameters
from rl_coach.schedules import LinearSchedule

from rl_coach.base_parameters import DistributedCoachSynchronizationType

import json


import tensorflow as tf
class MaxPooling2d(object):
    def __init__(self):
        pass

    def __call__(self, input_layer, name: str=None, is_training=None, pool_size int=2, stride int=2):
        """
        returns a tensorflow max_pool layer
        :param input_layer: previous layer
        :param name: layer name
        :return: max_pool layer
        """
        
        return tf.nn.max_pool(input_layer, ksize=[1, pool_size, pool_size, 1], strides=[1, stride, stride, 1], padding='SAME', name=name)
    
    def __str__(self):
        return "Maxpool layer"

class Conv2dWithAttention(object):
    def __init__(self, num_filters: int, kernel_size: int, strides: int, units: int):
        self.num_filters = num_filters
        self.kernel_size = kernel_size
        self.strides = strides
        self.units = units

    def __call__(self, input_layer, name: str=None, is_training=None):
        """
        returns a tensorflow conv2d layer
        :param input_layer: previous layer
        :param name: layer name
        :return: conv2d layer
        """

        conv = tf.layers.conv2d(input_layer, filters=self.num_filters, kernel_size=self.kernel_size,strides=self.strides, data_format='channels_last', name=name)
        W1 = Dense(self.units)
        V = Dense(1)
        score = tf.nn.tanh(W1(conv)) 
        attention_weights = tf.nn.softmax(V(score), axis=1)
        context_vector = attention_weights * conv 
        context_vector = tf.reduce_sum(context_vector, axis=1)
        return context_vector


    def __str__(self):
        return "Convolution (num filters = {}, kernel size = {}, stride = {})"\
            .format(self.num_filters, self.kernel_size, self.strides)


####################
# Graph Scheduling #
####################

schedule_params = ScheduleParameters()
schedule_params.improve_steps = TrainingSteps(10000000)
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

#agent_params.network_wrappers['main'].input_embedders_parameters = {
#    'observation': InputEmbedderParameters(
#        scheme=[
#                Conv2d(num_filters=32, kernel_size=8, strides=4),
#                Conv2d(num_filters=64, kernel_size=4, strides=2),
#                Conv2d(num_filters=64, kernel_size=3, strides=1)
#            ],
#        activation_function='relu', dropout_rate=0.3)    
#    }
#agent_params.network_wrappers['main'].middleware_parameters = \
# FCMiddlewareParameters(
#     scheme=[
#         Dense(512)
#     ],
#     activation_function='relu', dropout_rate=0.3
# )

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
                Conv2d(64, 3, 1),
                Conv2d(64, 3, 1),
                MaxPooling2d(2, 2),
                Conv2d(128, 3, 1),
                Conv2d(128, 3, 1),
                MaxPooling2d(2, 2),
                Conv2d(256, 3, 1),
                Conv2d(256, 3, 1),
                Conv2d(256, 3, 1),
                MaxPooling2d(2, 2),
                Conv2d(512, 3, 1),
                Conv2d(512, 3, 1),
                Conv2d(512, 3, 1),
                MaxPooling2d(2, 2)
                #Conv2d(512, 3, 1),
                #Conv2d(512, 3, 1),
                #Conv2d(512, 3, 1),
                #MaxPooling2d(),
                #Dense(4096),
                #Dense(4096)
            ],
            activation_function='relu', dropout_rate=0.3)}

agent_params.network_wrappers['main'].middleware_parameters = FCMiddlewareParameters(
            scheme=[
                #Dense(1024),
                Dense(1024),
                Dense(1024)
            ],
            activation_function='relu', dropout_rate=0.3
        )
#agent_params.network_wrappers['main'].input_embedders_parameters['observation'].activation_function = 'relu'
#agent_params.network_wrappers['main'].input_embedders_parameters['observation'].dropout_rate = 0.3
#agent_params.network_wrappers['main'].input_embedders_parameters['observation'].batchnorm = True
#agent_params.network_wrappers['main'].middleware_parameters.activation_function='relu'
#agent_params.network_wrappers['main'].middleware_parameters.dropout_rate=0.3

#agent_params.network_wrappers['main'].learning_rate = params["lr"]
#agent_params.network_wrappers['main'].middleware_parameters.activation_function = 'relu'
agent_params.network_wrappers['main'].batch_size = 64
agent_params.network_wrappers['main'].optimizer_epsilon = 1e-5
agent_params.network_wrappers['main'].adam_optimizer_beta2 = 0.999

agent_params.algorithm.clip_likelihood_ratio_using_epsilon = 0.2
agent_params.algorithm.clipping_decay_schedule = LinearSchedule(1.0, 0, 1000000)
agent_params.algorithm.beta_entropy = 0.01  # also try 0.001
agent_params.algorithm.gae_lambda = 0.95
agent_params.algorithm.discount = 0.999
agent_params.algorithm.optimization_epochs = 10
agent_params.algorithm.estimate_state_value_using_gae = True
#agent_params.algorithm.num_steps_between_copying_online_weights_to_target = EnvironmentEpisodes(20)
#agent_params.algorithm.num_consecutive_playing_steps = EnvironmentEpisodes(20)
#agent_params.algorithm.num_steps_between_copying_online_weights_to_target = EnvironmentEpisodes(
#        params["num_episodes_between_training"])
#agent_params.algorithm.num_consecutive_playing_steps = EnvironmentEpisodes(params["num_episodes_between_training"])

agent_params.exploration = CategoricalParameters()

agent_params.algorithm.distributed_coach_synchronization_type = DistributedCoachSynchronizationType.SYNC


###############
# Environment #
###############
SilverstoneInputFilter = InputFilter(is_a_reference_filter=True)

SilverstoneInputFilter.add_observation_filter('observation', 'to_grayscale', ObservationRGBToYFilter())
SilverstoneInputFilter.add_observation_filter('observation', 'to_uint8', ObservationToUInt8Filter(0, 255))
SilverstoneInputFilter.add_observation_filter('observation', 'stacking', ObservationStackingFilter(1))

env_params = GymVectorEnvironment()
env_params.default_input_filter = SilverstoneInputFilter
env_params.level = 'DeepRacerRacetrackCustomActionSpaceEnv-v0'

vis_params = VisualizationParameters()
vis_params.dump_mp4 = False

########
# Test #
########
preset_validation_params = PresetValidationParameters()
preset_validation_params.test = True
preset_validation_params.min_reward_threshold = 400
preset_validation_params.max_episodes_to_achieve_reward = 1000

graph_manager = BasicRLGraphManager(agent_params=agent_params, env_params=env_params,
                                    schedule_params=schedule_params, vis_params=vis_params,
                                    preset_validation_params=preset_validation_params)
