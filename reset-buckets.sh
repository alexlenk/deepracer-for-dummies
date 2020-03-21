#!/bin/bash

docker run -v ~/deepracer-for-dummies:/mnt centos:latest rm -rf /mnt/docker/volumes/minio/bucket/rl-deepracer-sagemaker/

#mkdir -p ~/deepracer-for-dummies/docker/volumes/minio/bucket/custom_files \
#		 ~/deepracer-for-dummies/docker/volumes/robo/checkpoint

#cp ~/deepracer-for-dummies/deepracer/custom_files/* ~/deepracer-for-dummies/docker/volumes/minio/bucket/custom_files/