#!/bin/bash

for arg in "$@";
do
    IFS='=' read -ra part <<< "$arg"
    if [ "${part[0]}" == "--j" ]; then
        j=${part[1]}
    fi
    if [ "${part[0]}" == "--skipped" ]; then
        skipped=${part[1]}
    fi
    if [ "${part[0]}" == "--start-time" ]; then
        START_TIME=${part[1]}
    fi
done

if [ "$j" == "" -o "$j" == "0" ]; then
    j=0
    rm ~/deepracer.log
    touch ~/deepracer.log
    rm ../../docker/volumes/minio/bucket/custom_files/eval_metrics_last.json
    touch ../../docker/volumes/minio/bucket/custom_files/eval_metrics_last.json
    mkdir ../../docker/volumes/minio/bucket/train_stats
    START_TIME=$(date +%Y-%m-%d_%H-%M-%S)
else
    echo "############################### RESUME TRAINING ###############################"
    echo "############################### RESUME TRAINING ###############################"
    if [ "$START_TIME" == "" -o "$START_TIME" == "0" ]; then
        echo "Starttime missing!"
        exit 1
    fi
    cp ../../docker/volumes/minio/bucket/train_stats/${START_TIME}_deepracer.log ~/deepracer.log 
    train_arg="--resume"
fi

echo "Starting in round J=$j"
model_keep=0

killall tail
tail -f ~/deepracer.log &

./stop.sh
while true; do
    . ./round_training.sh $train_arg >> ~/deepracer.log
done