#!/bin/bash
### Simple way for restoring after using the backup way.

VOLUMES_STRING=$(docker inspect --format="{{.Volumes}}" docker_postgresqldataonly_1)
MOUNTED_FOLDER=$(echo $VOLUMES_STRING | cut -d':' -f2)
MOUNTED_FOLDER=$(echo ${MOUNTED_FOLDER::-1})

docker stop docker_postgresqlrun_1

rm -rf $MOUNTED_FOLDER/*

cp -rp $1/* $MOUNTED_FOLDER

docker start docker_postgresqlrun_1