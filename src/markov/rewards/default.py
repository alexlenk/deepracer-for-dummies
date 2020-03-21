import numpy as np
import math

def reward_function(params):
    '''
    Example of rewarding the agent to stay inside the two borders of the track
    '''
    
    training_run = 0
    try:
        training_run = int(os.environ.get("TRAINING_RUN_TOTAL", 0))
    except Exception as ex:
        print("No training round variable found")
    
    global allrounds
    global round_speed
    global round_reward
    global fastest_round
    global last_sign
    global base_bracket
    global floating_rounds
    global trys
    global last_progress

    steps = params['steps']
    progress = params['progress']
    speed = params['speed']
    
    if steps == 0:
        round_speed = 0
        trys += 1
    
    # Read input parameters
    all_wheels_on_track = params['all_wheels_on_track']
    distance_from_center = params['distance_from_center']
    track_width = params['track_width']
    steering = abs(params['steering_angle']) # Only need the absolute steering angle
    track_length = len(params['waypoints'])
    
    # Give a very low reward by default
    reward = 1e-3

    # Give a high reward if no wheels go off the track and
    # the agent is somewhere in between the track borders
    if all_wheels_on_track:
        bonus = (progress - last_progress) * 10
    else:
        bonus = (progress - last_progress) * 7

    reward = bonus
    # Pretrain the model for xx runs
    if training_run <= 5:
        reward -= (distance_from_center / (track_width/2))**(4)
    reward = max(reward, 0.5)

    if abs(params["steering_angle"]) < 5:
        reward *= 2
    if np.sign(params['steering_angle']) == last_sign:
        reward *= 2

    last_sign = np.sign(params['steering_angle'])
    
    round_speed += speed
    round_reward += reward
    if progress == 100:
        floating_rounds[trys%10] = 1
        
        allrounds += 1
        if steps < fastest_round:
            fastest_round = steps
        if base_bracket == 1e5:
            base_bracket = math.ceil(fastest_round/300)*300

        speed_reward = (base_bracket - steps) ** 1.2
        base_reward = int(reward)
        
        reward += int(500)
        reward += int(speed_reward)
        
        total_reward = round_reward + reward
        
        print("Total Points: " + str(total_reward) + ", Base Points: " + str(base_reward) + ", Round Points: " + str(round_reward) + ", Speed Points: " + str(speed_reward))
        print("Current Lap: " + str(steps / 10) + " sec, Avg Speed: " + str(float(round_speed) / float(steps)))
    else:
        floating_rounds[trys%10] = 0    
    print("Progress: " + str(progress) + ", Speed: " + str(speed))    
    print("All Finished Laps: " + str(allrounds) + ", Fastest Round: " + str(fastest_round) + " Steps")
    print("Reward: " + str(reward))
    
    last_progress = progress
    
    # Always return a float value
    return float(reward)

last_sign = 0
unrewarded_allrounds = 0
unrewarded_rounds = 0
fastest_round = 1e5
base_bracket = 1e5
allrounds = 0
floating_rounds = np.zeros((10))
round_speed = 0
round_reward = 0
trys = -1
last_progress = 0.0