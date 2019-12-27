#!/bin/bash

docker run -v ~/deepracer-for-dummies:/mnt centos:latest rm -Rf /mnt/docker/volumes
docker run -v ~/deepracer-for-dummies:/mnt centos:latest rm -Rf rm -Rf /mnt/deepracer
docker run -v ~/deepracer-for-dummies:/mnt centos:latest rm -Rf rm -Rf /mnt/aws-deepracer-workshops
docker rmi aschu/rl_coach:latest
docker rmi minio/minio:latest
docker rmi crr0004/deepracer_robomaker:console
docker rmi crr0004/sagemaker-rl-tensorflow:nvidia
rm rl_deepracer_coach_robomaker.py
