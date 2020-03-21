#!/usr/bin/env bash

BACKUP_LOC=~/deepracer-training/backup
FILENAME=$1$(date +%Y-%m-%d_%H-%M-%S)
cp ../../docker/volumes/minio/bucket/custom_files/eval_metrics_last.json $BACKUP_LOC/${FILENAME}_eval.json
tar -czvf ${FILENAME}.tar.gz ../../docker/volumes/minio/bucket/rl-deepracer-pretrained/*
mv ${FILENAME}.tar.gz $BACKUP_LOC
