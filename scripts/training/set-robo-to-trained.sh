#!/bin/bash

rm -rf ../../volumes/robo/checkpoint/checkpoint/*
cp ../../docker/volumes/minio/bucket/rl-deepracer-sagemaker/model/* ../../docker/volumes/robo/checkpoint/checkpoint/
