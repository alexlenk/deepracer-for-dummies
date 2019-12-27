#!/bin/bash

docker run -v ~/deepracer-for-dummies:/mnt centos:latest rm -Rf /mnt/docker/volume

mkdir -p docker/volumes/minio/bucket/custom_files \
		 docker/volumes/robo/checkpoint

cp deepracer/custom_files/* docker/volumes/minio/bucket/custom_files/
