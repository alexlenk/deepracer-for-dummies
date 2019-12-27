#!/usr/bin/env bash

echo "Uploading rewards file"
cp ../../src/markov/rewards/default.py ../../docker/volumes/minio/bucket/custom_files/reward.py
echo "Uploading actions file"
cp ../../src/markov/actions/model_metadata.json ../../docker/volumes/minio/bucket/custom_files/model_metadata.json
echo "Uploading preset file"
cp ../../src/markov/presets/default.py ../../docker/volumes/minio/bucket/custom_files/preset.py

./start.sh
