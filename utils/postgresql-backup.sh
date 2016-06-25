#!/bin/bash
### Simple way to backup data from docker container
VOLUMES_STRING=$(docker inspect --format="{{.Volumes}}" docker_postgresqldataonly_1)
MOUNTED_FOLDER=$(echo $VOLUMES_STRING | cut -d':' -f2)
MOUNTED_FOLDER=$(echo ${MOUNTED_FOLDER::-1})

docker stop docker_odoodev_run_1 docker_postgresqlrun_1

cp -rp $MOUNTED_FOLDER $1/