#!/bin/bash

if [ "$1" == "" ]; then
    echo "Error: No Tar"
    exit
fi

./stop.sh
docker run -v ~:/mnt centos:latest rm -rf /mnt/deepracer-for-dummies/docker/volumes/minio/bucket/rl-deepracer-pretrained
docker run -v ~:/mnt centos:latest rm -rf /mnt/deepracer-for-dummies/docker/volumes/minio/bucket/rl-deepracer-sagemaker
tar xvfz ~/deepracer-training/backup/$1 -C ~/deepracer-for-dummies/
./set-last-run-to-pretrained.sh

../../reset-checkpoint.sh

#./round_training.sh --resume
