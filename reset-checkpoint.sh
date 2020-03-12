#!/bin/bash

docker run -v ~/deepracer-for-dummies:/mnt centos:latest rm -rf /mnt/docker/volumes/robo

mkdir ~/deepracer-for-dummies/docker/volumes/robo
