#!/bin/bash

echo "Uploading rewards file"
cp ../../src/markov/rewards/default.py ../../docker/volumes/minio/bucket/custom_files/reward.py
echo "Uploading actions file"
cp ../../src/markov/actions/model_metadata.json ../../docker/volumes/minio/bucket/custom_files/model_metadata.json
echo "Uploading preset file"
cp ../../src/markov/presets/default.py ../../docker/volumes/minio/bucket/custom_files/preset.py

if [ "$WORLD" == "" -o "$WORLD" == "null" ]; then
    WORLD=reinvent_base
fi

if [ "$TEST" == "" -o "$TEST" == "null" ]; then
    TEST=False
fi

if [ "$X_NUMBER_OF_TRIALS" == "" -o "$X_NUMBER_OF_TRIALS" == "null" ]; then
    X_NUMBER_OF_TRIALS=21
fi

../../reset-checkpoint.sh

echo "Eval: Evaluating for $X_NUMBER_OF_TRIALS rounds"

if [ "$reeval" == "true" ]; then
    echo "Eval: Using pre-trained model"
    sed -i 's/#"pretrained_s3_bucket"/"pretrained_s3_bucket"/g' ../../deepracer/rl_coach/rl_deepracer_coach_robomaker.py
    sed -i 's/#"pretrained_s3_prefix"/"pretrained_s3_prefix"/g' ../../deepracer/rl_coach/rl_deepracer_coach_robomaker.py
else
    echo "Eval: Using currently trained model"
    sed -i 's/[^#]"pretrained_s3_bucket"/ #"pretrained_s3_bucket"/g' ../../deepracer/rl_coach/rl_deepracer_coach_robomaker.py
    sed -i 's/[^#]"pretrained_s3_prefix"/ #"pretrained_s3_prefix"/g' ../../deepracer/rl_coach/rl_deepracer_coach_robomaker.py
fi

sed "s/###WORLD###/$WORLD/g" ../../docker/template.env > ../../docker/.env
sed -i 's/metric.json/eval_metrics.json/g' ../../docker/.env
sed -i "s/NUMBER_OF_TRIALS=5/NUMBER_OF_TRIALS=$X_NUMBER_OF_TRIALS/g" ../../docker/.env
echo "ALTERNATE_DRIVING_DIRECTION=True" >> ../../docker/.env
echo "CHANGE_START_POSITION=True" >> ../../docker/.env
echo "EVALUATION_TEST=$TEST" >> ../../docker/.env
echo "TRAINING_RUN_TOTAL=$j" >> ../../docker/.env
echo "TRAINING_RUN=$((j-skipped))" >> ../../docker/.env
echo "MEDIAN_PERCENTAGE=$curr_median_perc" >> ../../docker/.env
echo "AVERAGE_PERCENTAGE=$curr_avg_perc" >> ../../docker/.env

rm -f ../../docker/volumes/minio/bucket/custom_files/eval_metrics.json
touch ../../docker/volumes/minio/bucket/custom_files/eval_metrics.json

cat ../../docker/.env
. ../evaluation/start.sh > ~/deepracer_eval.log &
RUNNING=true

while [ $RUNNING == true ]; do
    complete=`jq -r ".metrics[$(($X_NUMBER_OF_TRIALS-1))].completion_percentage" ../../docker/volumes/minio/bucket/custom_files/eval_metrics.json`
    
    if [ "$complete" == "null" -o "$complete" == "" ] ; then
        RUNNING=true
    else
        RUNNING=false
    fi
    sleep 5
    #cat ../../docker/volumes/minio/bucket/custom_files/eval_metrics.json
done

cat ../../docker/volumes/minio/bucket/custom_files/eval_metrics.json

. ./stop.sh
