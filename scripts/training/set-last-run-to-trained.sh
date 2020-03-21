#!/usr/bin/env bash
Folder=rl-deepracer-pretrained
if [ -d ../../docker/volumes/minio/bucket/rl-deepracer-pretrained ];
then
	echo "Folder $Folder  exist."
	rm -rf ../../docker/volumes/minio/bucket/rl-deepracer-sagemaker
    mkdir ../../docker/volumes/minio/bucket/rl-deepracer-sagemaker
	cp -rf ../../docker/volumes/minio/bucket/rl-deepracer-pretrained/* ../../docker/volumes/minio/bucket/rl-deepracer-sagemaker
	echo "Done."

else
	echo "Folder $Folder does not exist" 
fi
