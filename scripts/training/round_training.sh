#!/bin/bash

if [ "$START_TIME" == "" -o "$START_TIME" == "0" ]; then
    START_TIME="2020-02-28_16-06-31"
fi

PREFIX=${START_TIME}_
TEST=False
reeval=false

WORLDS=(New_York_Track China_track Virtual_May19_Train_track Mexico_track Tokyo_Training_track Canada_Training Bowtie_track)
LEN_WORLDS=${#WORLDS[@]}

GRASS_TEXTURES_SIMPLE=(New_York_Track/textures/Wood.png reinvent/textures/Road_DIFF.png New_York_Track/textures/Concrete_01.png New_York_Track/textures/Concrete_02.png New_York_Track/textures/Concrete_03.png New_York_Track/textures/Concrete_04.png New_York_Track/textures/Concrete_05.png New_York_Track/textures/Concrete_06.png New_York_Track/textures/Concrete_07.png Canada_Training/textures/Canada_track_concrete_T_01.png Canada_Training/textures/Canada_track_concrete_T_02.png Canada_Training/textures/Canada_track_concrete_T_03.png Canada_Training/textures/Canada_track_concrete_T_04.png Canada_Training/textures/Canada_track_concrete_T_05.png New_York_Track/textures/Track_road_01.png)

GRASS_TEXTURES=(China_track/textures/China_track_landmark_U_01.png China_track/textures/China_track_landmark_U_04.png China_track/textures/China_track_landmark_U_07.png China_track/textures/China_track_glass_T_01.png China_track/textures/China_track_glass_T_03.png China_track/textures/China_track_glass_T_05.png China_track/textures/China_track_sea_U_02.png China_track/textures/China_track_sign_U_01.png Mexico_track/textures/Mexico_track_door_U_02.png Mexico_track/textures/Mexico_track_door_U_01.png Mexico_track/textures/Mexico_track_landmark_U_02.png Mexico_track/textures/Mexico_track_landmark_U_03_01.png Mexico_track/textures/Mexico_track_landmark_U_03_02.png Mexico_track/textures/Mexico_track_landmark_U_05.png Mexico_track/textures/Mexico_track_building_wall_U_01.png Canada_Training/textures/Canada_track_cloud_T_01.png Canada_Training/textures/Canada_track_building_wall_U_01.png New_York_Track/textures/Signs_02.png)

#GRASS_TEXTURES=$GRASS_TEXTURES_COMPLEX

ROAD_TEXTURES_SIMPLE=(reInvent2019_track/textures/Bowtie_track_field.png reinvent/textures/Grass_DIFF.pngNew_York_Track/textures/Concrete_01.png New_York_Track/textures/Concrete_02.png New_York_Track/textures/Concrete_03.png New_York_Track/textures/Concrete_04.png New_York_Track/textures/Concrete_05.png New_York_Track/textures/Concrete_06.png New_York_Track/textures/Concrete_07.png Canada_Training/textures/Canada_track_concrete_T_01.png Canada_Training/textures/Canada_track_concrete_T_02.png Canada_Training/textures/Canada_track_concrete_T_03.png Canada_Training/textures/Canada_track_concrete_T_04.png Canada_Training/textures/Canada_track_concrete_T_05.png New_York_Track/textures/Wood.png Virtual_May19_Train_track/textures/Virtual_May19_Comp_track_field.png New_York_Track/textures/Track_field_grass_01.png reInvent2019_track/textures/Bowtie_track_field.png reinvent/textures/Grass_DIFF.png)

ROAD_TEXTURES=(China_track/textures/China_track_landmark_U_01.png China_track/textures/China_track_landmark_U_04.png China_track/textures/China_track_landmark_U_07.png China_track/textures/China_track_glass_T_01.png China_track/textures/China_track_glass_T_03.png China_track/textures/China_track_glass_T_05.png China_track/textures/China_track_sea_U_02.png China_track/textures/China_track_sign_U_01.png Mexico_track/textures/Mexico_track_door_U_02.png Mexico_track/textures/Mexico_track_door_U_01.png Mexico_track/textures/Mexico_track_landmark_U_02.png Mexico_track/textures/Mexico_track_landmark_U_03_01.png Mexico_track/textures/Mexico_track_landmark_U_03_02.png Mexico_track/textures/Mexico_track_landmark_U_05.png Mexico_track/textures/Mexico_track_building_wall_U_01.png Canada_Training/textures/Canada_track_cloud_T_01.png Canada_Training/textures/Canada_track_building_wall_U_01.png New_York_Track/textures/Signs_02.png) 

#ROAD_TEXTURES=$ROAD_TEXTURES_COMPLEX

WALL_TEXTURES=(reinvent/textures/walls_light.jpg reinvent/textures/walls_org.jpg reinvent/textures/walls_dark.jpg)
WALL_TEXTURES2019=(reInvent2019_track/textures/walls_light.png reInvent2019_track/textures/wall.png reInvent2019_track/textures/walls_dark.png)

declare -A GRASS
GRASS[New_York_Track]=New_York_Track/textures/Track_field_grass_01.png
GRASS[China_track]=China_track/textures/China_track_field_grass_T_01.png
GRASS[Virtual_May19_Train_track]=Virtual_May19_Train_track/textures/Virtual_May19_Comp_track_field.png
GRASS[Mexico_track]=Mexico_track/textures/Mexico_Track_field_grass_T_01.png
GRASS[Tokyo_Training_track]=Tokyo_Training_track/textures/Track_field_grass_01.png
GRASS[reInvent2019_track]=reInvent2019_track/textures/Bowtie_track_field.png
GRASS[reinvent_base]=reinvent/textures/Grass_DIFF.png
GRASS[Canada_Training]=Canada_Training/textures/Canada_track_field_grass_01.png
GRASS[Bowtie_track]=Bowtie_track/textures/Bowtie_track_field.png

declare -A ROADS
ROADS[New_York_Track]=New_York_Track/textures/Track_road_01.png
ROADS[China_track]=China_track/textures/China_track_road_T_01.png
ROADS[Virtual_May19_Train_track]=Virtual_May19_Train_track/textures/Virtual_May19_Comp_track_road.png
ROADS[Mexico_track]=Mexico_track/textures/Mexico_track_road_T_01.png
ROADS[Tokyo_Training_track]=Tokyo_Training_track/textures/Track_road_01.png
ROADS[reInvent2019_track]=reInvent2019_track/textures/Bowtie_track_road.png
ROADS[reinvent_base]=reinvent/textures/Road_DIFF.png
ROADS[Canada_Training]=Canada_Training/textures/Canada_track_road_T_01.png
ROADS[Bowtie_track]=Bowtie_track/textures/Bowtie_track_road.png

declare -A WALLS
WALLS[reInvent2019_track]=reInvent2019_track/textures/wall.png
WALLS[reinvent_base]=reinvent/textures/walls.jpg

# reinvent_lines_walls reinvent_carpet 

first=true
#j=0

for arg in "$@";
do
    IFS='=' read -ra part <<< "$arg"
    if [ "${part[0]}" == "--resume" ]; then
        first=false
    fi
done

if [ "$j" -gt "0" ]; then
    first=false
fi

if [ -f "../../docker/volumes/minio/bucket/train_stats/${PREFIX}skipped-tracks" ]; then
    skipped_tracks=(`awk '{print ($3)}' ../../docker/volumes/minio/bucket/train_stats/${PREFIX}skipped-tracks | tr "\n" " "`)
else
    skipped_tracks=()
fi
if [ -f "../../docker/volumes/minio/bucket/train_stats/${PREFIX}trained-tracks" ]; then
    trained_tracks=(`awk '{print ($3)}' ../../docker/volumes/minio/bucket/train_stats/${PREFIX}trained-tracks | tr "\n" " "`)
else
    trained_tracks=()
fi

skipped=${#skipped_tracks[@]}

#road_mod_rounds=$((${#WORLDS[@]}*1-1))
#grass_mod_rounds=$((${#WORLDS[@]}*1-1))
road_mod_rounds=-1
grass_mod_rounds=-1
speed_up_rounds=-1


WORLD=${WORLDS[$(($j % $LEN_WORLDS))]}
echo "######################### Starting Training Round: $j (Netto: $((j-skipped))) with $WORLD (Reverse: $reverse; $(date +%Y-%m-%d_%H-%M-%S)) ##################################"
echo "######################### Road-Mod-Rounds: $road_mod_rounds; Grass-Mod-Rounds: $grass_mod_rounds; Speed-Up: $speed_up_rounds ##################################"
echo "Round: $START_TIME"
echo "Trained Tracks: ${trained_tracks[*]}"
echo "Skipped Tracks: ${skipped_tracks[*]}"
if [ "$first" == true ] ; then
    echo "Starting new training"
    rm ../../docker/volumes/minio/bucket/custom_files/eval_metrics_last.json
    touch ../../docker/volumes/minio/bucket/custom_files/eval_metrics_last.json
    first=false
    sed -i 's/[^#]"pretrained_s3_bucket"/ #"pretrained_s3_bucket"/g' ../../deepracer/rl_coach/rl_deepracer_coach_robomaker.py
    sed -i 's/[^#]"pretrained_s3_prefix"/ #"pretrained_s3_prefix"/g' ../../deepracer/rl_coach/rl_deepracer_coach_robomaker.py
else
    echo "Resuming training"
    sed -i 's/#"pretrained_s3_bucket"/"pretrained_s3_bucket"/g' ../../deepracer/rl_coach/rl_deepracer_coach_robomaker.py
    sed -i 's/#"pretrained_s3_prefix"/"pretrained_s3_prefix"/g' ../../deepracer/rl_coach/rl_deepracer_coach_robomaker.py
fi
#cat ../../rl_deepracer_coach_robomaker.py
sed "s/###WORLD###/$WORLD/g" ../../docker/template.env > ../../docker/.env

if [ "$reverse" == "true" ]; then
    echo "REVERSE_DIR=True" >> ../../docker/.env
    direction="Reverse"
else
    direction="Normal"
fi

echo "TRAINING_RUN_TOTAL=$j" >> ../../docker/.env
echo "TRAINING_RUN=$((j-skipped))" >> ../../docker/.env
echo "MEDIAN_PERCENTAGE=$curr_median_perc" >> ../../docker/.env
echo "AVERAGE_PERCENTAGE=$curr_avg_perc" >> ../../docker/.env

if [ "$j" -gt "$road_mod_rounds" ] ; then
    TEX_ROAD=${ROAD_TEXTURES[$RANDOM % ${#ROAD_TEXTURES[@]} ]}
    echo "######################### Road-Texture: $TEX_ROAD ##################################"
    cp ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${ROADS[$WORLD]} ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${ROADS[$WORLD]}.org
    cp ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/$TEX_ROAD ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${ROADS[$WORLD]}
    if [ "$WORLD" == "reinvent_base" ] ; then
        TEX=${WALL_TEXTURES[$RANDOM % ${#WALL_TEXTURES[@]} ]}
        echo "######################### Wall-Texture: $TEX ##################################"
        cp ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${WALLS[$WORLD]} ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${WALLS[$WORLD]}.org
        cp ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/$TEX ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${WALLS[$WORLD]}
    fi
    if [ "$WORLD" == "reInvent2019_track" ] ; then
        TEX=${WALL_TEXTURES2019[$RANDOM % ${#WALL_TEXTURES2019[@]} ]}
        echo "######################### Wall-Texture: $TEX ##################################"
        cp ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${WALLS[$WORLD]} ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${WALLS[$WORLD]}.org
        cp ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/$TEX ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${WALLS[$WORLD]}
    fi
fi

if [ "$j" -gt "$grass_mod_rounds" ] ; then
    cp ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${GRASS[$WORLD]} ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${GRASS[$WORLD]}.org
    TEX_GRASS=${GRASS_TEXTURES[$RANDOM % ${#GRASS_TEXTURES[@]} ]}
    echo "######################### Grass-Texture: $TEX_GRASS ##################################"
    cp ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/$TEX_GRASS ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${GRASS[$WORLD]}
fi

#cat ../../docker/.env
../../reset-buckets.sh
../../reset-checkpoint.sh
. ./adv-start.sh  >> ~/deepracer.log &
sleep 30

docker exec -t $(docker ps | grep sagemaker | cut -d' ' -f1) redis-cli config set client-output-buffer-limit 'slave 10737418240 10737418240 0'
docker exec -t $(docker ps | grep sagemaker | cut -d' ' -f1) redis-cli config set maxmemory 10737418240

mv ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${ROADS[$WORLD]}.org ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${ROADS[$WORLD]}
mv ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${WALLS[$WORLD]}.org ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${WALLS[$WORLD]}
mv ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${GRASS[$WORLD]}.org ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${GRASS[$WORLD]}

if [ "$j" -gt "$speed_up_rounds" ] ; then
    train_time=3600
    #train_time=300
else
    train_time=1800
    #sleep 300
fi

echo "################ Training for $train_time seconds #################"
sleep $train_time

./stop.sh
        
### Evaluation ###
echo "### Saving Checkpoint file before Evaluation:"
cat ../../docker/volumes/minio/bucket/rl-deepracer-sagemaker/model/checkpoint
docker run -v ~/deepracer-for-dummies:/mnt -w /mnt/scripts/training centos cp -f ../../docker/volumes/minio/bucket/rl-deepracer-sagemaker/model/checkpoint ../../docker/volumes/minio/bucket/rl-deepracer-sagemaker/model/checkpoint.sav
WORLD_TRAIN=$WORLD
#WORLD=reInvent2019_track
X_NUMBER_OF_TRIALS=21
rm ../../docker/volumes/minio/bucket/custom_files/eval_metrics_rounds.json
touch ../../docker/volumes/minio/bucket/custom_files/eval_metrics_rounds.json

cp ../../textures/reInvent2019_track/textures/org-road.png ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${ROADS[reInvent2019_track]}
cp ../../textures/reInvent2019_track/textures/org-wall.png ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${WALLS[reInvent2019_track]}

cp ../../textures/reinvent/textures/org-road.png ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${ROADS[reinvent_base]}
cp ../../textures/reinvent/textures/org-wall.jpg ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${WALLS[reinvent_base]}

for WORLD in reInvent2019_track reinvent_base; do
    . ../evaluation/adv-start.sh >> ~/deepracer.log
    cat ../../docker/volumes/minio/bucket/custom_files/eval_metrics.json >> ../../docker/volumes/minio/bucket/custom_files/eval_metrics_rounds.json
    . ./echo_model_stats.sh >> ~/deepracer.log
    echo "### Restoring Checkpoint file:"
    docker run -v ~/deepracer-for-dummies:/mnt -w /mnt/scripts/training centos cp -f ../../docker/volumes/minio/bucket/rl-deepracer-sagemaker/model/checkpoint.sav ../../docker/volumes/minio/bucket/rl-deepracer-sagemaker/model/checkpoint
    cat ../../docker/volumes/minio/bucket/rl-deepracer-sagemaker/model/checkpoint
done
for WORLD in reInvent2019_track reinvent_base; do
    if [ "$WORLD" == "reinvent_base" ] ; then
        TEX_ROAD_EVAL=New_York_Track/textures/Wood.png
    
        TEX=reinvent/textures/walls_light_check.jpg
        echo "######################### Wall-Texture: $TEX ##################################"
        cp ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${WALLS[$WORLD]} ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${WALLS[$WORLD]}.org
        cp ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/$TEX ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${WALLS[$WORLD]}
    fi
    if [ "$WORLD" == "reInvent2019_track" ] ; then
        TEX_ROAD_EVAL=AWS_track/textures/ASW_track_field.png
    
        TEX=reInvent2019_track/textures/walls_dark_check.png
        echo "######################### Wall-Texture: $TEX ##################################"
        cp ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${WALLS[$WORLD]} ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${WALLS[$WORLD]}.org
        cp ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/$TEX ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${WALLS[$WORLD]}
    fi
    
    
    echo "######################### Road-Texture: $TEX_ROAD_EVAL ##################################"
    cp ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${ROADS[$WORLD]} ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${ROADS[$WORLD]}.org
    cp ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/$TEX_ROAD_EVAL ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${ROADS[$WORLD]}

    . ../evaluation/adv-start.sh >> ~/deepracer.log
    cat ../../docker/volumes/minio/bucket/custom_files/eval_metrics.json >> ../../docker/volumes/minio/bucket/custom_files/eval_metrics_rounds.json
    . ./echo_model_stats.sh >> ~/deepracer.log
    echo "### Restoring Checkpoint file:"
    docker run -v ~/deepracer-for-dummies:/mnt -w /mnt/scripts/training centos cp -f ../../docker/volumes/minio/bucket/rl-deepracer-sagemaker/model/checkpoint.sav ../../docker/volumes/minio/bucket/rl-deepracer-sagemaker/model/checkpoint
    cat ../../docker/volumes/minio/bucket/rl-deepracer-sagemaker/model/checkpoint
    
    mv ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${ROADS[$WORLD]}.org ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${ROADS[$WORLD]}
    mv ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${WALLS[$WORLD]}.org ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${WALLS[$WORLD]}
    mv ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${GRASS[$WORLD]}.org ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${GRASS[$WORLD]}
done

pat='model_checkpoint_path: "[0-9]+_Step-([0-9]+).*"'
[[ `cat ../../docker/volumes/minio/bucket/rl-deepracer-sagemaker/model/checkpoint` =~ $pat ]]
num_steps=${BASH_REMATCH[1]}
pat='model_checkpoint_path: "([0-9]+).*"'
[[ `cat ../../docker/volumes/minio/bucket/rl-deepracer-sagemaker/model/checkpoint` =~ $pat ]]
model_id="${BASH_REMATCH[1]}"

if [ "$train_time" == "1800" ]; then
    discount=90
else
    discount=100
fi

echo "Comparison: $median_perc -gt $last_median_perc"
# last_median_perc * 80 / 100
if [ $median_perc -gt $last_median_perc ] || [ $median_perc == $last_median_perc -a $avg_perc -gt $last_avg_perc ] || [ $avg_perc == $last_avg_perc -a $median_perc == $last_median_perc -a $last_avg_ms -gt $avg_ms ] || [ "$j" -lt "20" -a "$median_perc" = "100" -a "$avg_perc" -gt "8500" -a "$(($RANDOM%2))" = "1" ]; then
    cp ../../docker/volumes/minio/bucket/custom_files/eval_metrics_rounds.json ../../docker/volumes/minio/bucket/custom_files/eval_metrics_last.json
    echo "### EVALUATION RESULT: New model found - $WORLD_TRAIN"
    
    # Add additional files to Tar
    docker run -v ~/deepracer-for-dummies:/mnt centos chown 1011:1001 /mnt/docker/volumes/minio/bucket/rl-deepracer-sagemaker -R
    mkdir ~/deepracer-for-dummies/docker/volumes/minio/bucket/rl-deepracer-sagemaker/custom_files
    cp ~/deepracer-for-dummies/src/* ~/deepracer-for-dummies/docker/volumes/minio/bucket/rl-deepracer-sagemaker/custom_files
    cp ../../src/markov/* ~/deepracer-for-dummies/docker/volumes/minio/bucket/rl-deepracer-sagemaker/custom_files
    cp ../../rl_deepracer_coach_robomaker.py ~/deepracer-for-dummies/docker/volumes/minio/bucket/rl-deepracer-sagemaker/custom_files
    cp ~/deepracer-for-dummies/docker/volumes/minio/bucket/custom_files/* ~/deepracer-for-dummies/docker/volumes/minio/bucket/rl-deepracer-sagemaker/custom_files
    cp ~/deepracer.log ~/deepracer-for-dummies/docker/volumes/minio/bucket/rl-deepracer-sagemaker/
    
    #./back-up-pretraining-run.sh ${PREFIX}new-best_j-$((j-1))_mp-${last_median_perc}_ap-${last_avg_perc}_
    docker run -v ~/deepracer-for-dummies:/mnt -w /mnt/scripts/training centos ./set-last-run-to-pretrained.sh
    ./back-up-pretraining-run.sh ${PREFIX}new-best_j-${j}_mp-${median_perc}_ap-${avg_perc}_
    
    FILENAME=${PREFIX}new-best_j-${j}_mp-${median_perc}_ap-$avg_perc
    cp ../../docker/volumes/minio/bucket/rl-deepracer-pretrained/model/model_$model_id.pb ../../../deepracer-training/model/model.pb
    cp ../../docker/volumes/minio/bucket/rl-deepracer-pretrained/model/model_metadata.json ../../../deepracer-training/model/model_metadata.json
    cp ../../src/markov/rewards/default.py ../../../deepracer-training/model/rewards.py
    cp ../../src/markov/* ../../../deepracer-training/model/
    cp ../../rl_deepracer_coach_robomaker.py ../../../deepracer-training/model/
    cp ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/sagemaker_rl_agent/markov/sagemaker_graph_manager.py ../../../deepracer-training/model/
    
    tar cvfz ../../../deepracer-training/$FILENAME.tar.gz -C ../../../deepracer-training/model/ model.pb model_metadata.json sagemaker_graph_manager.py rewards.py deepracer_racetrack_env.py rl_deepracer_coach_robomaker.py
    #tar cvfz -C ../../../deepracer-training/model/ ../../docker/volumes/minio/bucket/rl-deepracer-pretrained/model/model.pb
    
    ../../reset-checkpoint.sh
    trained_tracks+=( ${WORLD_TRAIN}_$direction )
    
    #docker run -v ~/deepracer-for-dummies:/mnt centos chown 1011:1001 /mnt/docker/volumes/minio/bucket/rl-deepracer-sagemaker -R
    echo -e "$(date +%Y-%m-%d_%H-%M-%S)\t$j\t${WORLD_TRAIN}\t$direction\t$TEX_ROAD\t$TEX_GRASS\t$full_rounds/$cnt_rounds\t${median_perc}\t$avg_perc\t$avg_ms\t$model_id\t$num_steps" >> ../../docker/volumes/minio/bucket/train_stats/${PREFIX}trained-tracks
    ((j=j+1))
    echo "Increasing J to $j"
    model_keep=0
    new_model=true
    reverse=false
    curr_median_perc=$median_perc
    curr_avg_perc=$avg_perc
else
    #docker run -v ~/deepracer-for-dummies:/mnt centos chown 1011:1001 /mnt/docker/volumes/minio/bucket/rl-deepracer-sagemaker -R
    echo -e "$(date +%Y-%m-%d_%H-%M-%S)\t$j\t${WORLD_TRAIN}\t$direction\t$TEX_ROAD\t$TEX_GRASS\t$full_rounds/$cnt_rounds\t${median_perc}\t$avg_perc\t$avg_ms\t$model_id\t$num_steps" >> ../../docker/volumes/minio/bucket/train_stats/${PREFIX}failed-training
    ((model_keep=model_keep+1))
    new_model=false
    echo "### EVALUATION RESULT: Keeping old model"
    curr_median_perc=$last_median_perc
    curr_avg_perc=$last_avg_perc
fi


if [ $model_keep == 2 ]; then
    #echo "## Checking Pre-Trained Checkpoint and backing up Pre-Trained dir"
    #cat ../../docker/volumes/minio/bucket/rl-deepracer-pretrained/model/checkpoint
    #./back-up-pretraining-run.sh ${START_TIME}_reeval_j${j}_mp${last_median_perc}_ap${last_avg_perc}_
    
    echo "######################### RE-EVALUATING BEST MODEL ($(date +%Y-%m-%d_%H-%M-%S)) ##################################"
    echo "######################### RE-EVALUATING BEST MODEL ($(date +%Y-%m-%d_%H-%M-%S)) ##################################"
    echo "######################### RE-EVALUATING BEST MODEL ($(date +%Y-%m-%d_%H-%M-%S)) ##################################"
    reeval=true
    ../../reset-buckets.sh
    ../../reset-checkpoint.sh
    rm ../../docker/volumes/minio/bucket/custom_files/eval_metrics_rounds.json
    touch ../../docker/volumes/minio/bucket/custom_files/eval_metrics_rounds.json
    
    cp ../../textures/reInvent2019_track/textures/org-road.png ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${ROADS[reInvent2019_track]}
    cp ../../textures/reInvent2019_track/textures/org-wall.png ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${WALLS[reInvent2019_track]}

    cp ../../textures/reinvent/textures/org-road.png ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${ROADS[reinvent_base]}
    cp ../../textures/reinvent/textures/org-wall.jpg ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${WALLS[reinvent_base]}

    for WORLD in reInvent2019_track reinvent_base; do
        . ../evaluation/adv-start.sh >> ~/deepracer.log
        cat ../../docker/volumes/minio/bucket/custom_files/eval_metrics.json >> ../../docker/volumes/minio/bucket/custom_files/eval_metrics_rounds.json
        . ./echo_model_stats.sh >> ~/deepracer.log
        echo "### Restoring Checkpoint file:"
        docker run -v ~/deepracer-for-dummies:/mnt -w /mnt/scripts/training centos cp -f ../../docker/volumes/minio/bucket/rl-deepracer-sagemaker/model/checkpoint.sav ../../docker/volumes/minio/bucket/rl-deepracer-sagemaker/model/checkpoint
        cat ../../docker/volumes/minio/bucket/rl-deepracer-sagemaker/model/checkpoint
    done
    for WORLD in reInvent2019_track reinvent_base; do
        if [ "$WORLD" == "reinvent_base" ] ; then
            TEX_ROAD_EVAL=New_York_Track/textures/Wood.png

            TEX=reinvent/textures/walls_light_check.jpg
            echo "######################### Wall-Texture: $TEX ##################################"
            cp ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${WALLS[$WORLD]} ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${WALLS[$WORLD]}.org
            cp ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/$TEX ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${WALLS[$WORLD]}
        fi
        if [ "$WORLD" == "reInvent2019_track" ] ; then
            TEX_ROAD_EVAL=AWS_track/textures/ASW_track_field.png

            TEX=reInvent2019_track/textures/walls_dark_check.png
            echo "######################### Wall-Texture: $TEX ##################################"
            cp ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${WALLS[$WORLD]} ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${WALLS[$WORLD]}.org
            cp ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/$TEX ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${WALLS[$WORLD]}
        fi


        echo "######################### Road-Texture: $TEX_ROAD_EVAL ##################################"
        cp ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${ROADS[$WORLD]} ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${ROADS[$WORLD]}.org
        cp ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/$TEX_ROAD_EVAL ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${ROADS[$WORLD]}

        . ../evaluation/adv-start.sh >> ~/deepracer.log
        cat ../../docker/volumes/minio/bucket/custom_files/eval_metrics.json >> ../../docker/volumes/minio/bucket/custom_files/eval_metrics_rounds.json
        . ./echo_model_stats.sh >> ~/deepracer.log
        echo "### Restoring Checkpoint file:"
        docker run -v ~/deepracer-for-dummies:/mnt -w /mnt/scripts/training centos cp -f ../../docker/volumes/minio/bucket/rl-deepracer-sagemaker/model/checkpoint.sav ../../docker/volumes/minio/bucket/rl-deepracer-sagemaker/model/checkpoint
        cat ../../docker/volumes/minio/bucket/rl-deepracer-sagemaker/model/checkpoint

        mv ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${ROADS[$WORLD]}.org ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${ROADS[$WORLD]}
        mv ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${WALLS[$WORLD]}.org ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${WALLS[$WORLD]}
        mv ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${GRASS[$WORLD]}.org ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${GRASS[$WORLD]}
    done

    
    
    cp ../../docker/volumes/minio/bucket/custom_files/eval_metrics_rounds.json ../../docker/volumes/minio/bucket/custom_files/eval_metrics_last.json
    reeval=false
    reverse=true
    curr_median_perc=$median_perc
    curr_avg_perc=$avg_perc
fi   


if [ "$new_model" == "true" -a "$median_perc" -gt "95" ] || [ ! -f "../../docker/volumes/minio/bucket/train_stats/${PREFIX}test-results" ] || [ "$(($j % 5))" == "0" ] || [ "$model_keep" == "2" ]; then
    cp ../../textures/reInvent2019_track/textures/org-road.png ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${ROADS[reInvent2019_track]}
    cp ../../textures/reInvent2019_track/textures/org-wall.png ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${WALLS[reInvent2019_track]}

    cp ../../textures/reinvent/textures/org-road.png ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${ROADS[reinvent_base]}
    cp ../../textures/reinvent/textures/org-wall.jpg ../../deepracer/simulation/aws-robomaker-sample-application-deepracer/simulation_ws/src/deepracer_simulation/meshes/${WALLS[reinvent_base]}


    echo "######################### TESTING BEST MODEL ##################################"
    echo "######################### TESTING BEST MODEL ##################################"
    echo "######################### TESTING BEST MODEL ##################################"

    ../../reset-buckets.sh
    ../../reset-checkpoint.sh
    echo "##### Testing Model #####"
    pat='model_checkpoint_path: "[0-9]+_Step-([0-9]+).*"'
    [[ `cat ../../docker/volumes/minio/bucket/rl-deepracer-pretrained/model/checkpoint` =~ $pat ]]
    num_steps=${BASH_REMATCH[1]}
    pat='model_checkpoint_path: "([0-9]+).*"'
    [[ `cat ../../docker/volumes/minio/bucket/rl-deepracer-pretrained/model/checkpoint` =~ $pat ]]
    model_id="${BASH_REMATCH[1]}"
    
    X_NUMBER_OF_TRIALS=11
    TEST=True
    reeval=true
    for WORLD in reInvent2019_track reinvent_base; do
        rm ../../docker/volumes/minio/bucket/custom_files/eval_metrics_rounds.json
        touch ../../docker/volumes/minio/bucket/custom_files/eval_metrics_rounds.json
        . ../evaluation/adv-start.sh >> ~/deepracer.log
        cat ../../docker/volumes/minio/bucket/custom_files/eval_metrics.json > ../../docker/volumes/minio/bucket/custom_files/eval_metrics_rounds.json
        . ./echo_model_stats.sh >> ~/deepracer.log
        echo -e "$(date +%Y-%m-%d_%H-%M-%S)\t${model_id}-${num_steps}\t${WORLD}\t$full_rounds/$cnt_rounds\t${median_perc}\t$avg_perc\t$avg_ms" >> ../../docker/volumes/minio/bucket/train_stats/${PREFIX}test-results
    done
    echo "### Restoring Checkpoint file:"
    cat ../../docker/volumes/minio/bucket/rl-deepracer-sagemaker/model/checkpoint
    reeval=false
    TEST=False
fi

if [ $model_keep == 4 ]; then
    echo "### Skipping Track"
    echo -e "$(date +%Y-%m-%d_%H-%M-%S)\t$j\t${WORLD_TRAIN}" >> ../../docker/volumes/minio/bucket/train_stats/${PREFIX}skipped-tracks
    ((j=j+1))
    skipped_tracks+=( $WORLD_TRAIN )
    model_keep=0
    reverse=false
fi

cp ../../docker/volumes/minio/bucket/custom_files/eval_metrics_last.json ../../docker/volumes/minio/bucket/train_stats/${PREFIX}eval_metrics_last.json
cp ~/deepracer.log ../../docker/volumes/minio/bucket/train_stats/${PREFIX}deepracer.log