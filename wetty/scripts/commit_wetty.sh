#!/bin/bash

docker container ls
echo "Enter container ID"
read CID
docker commit $CID root/wetty:latest 
docker image prune -f 
