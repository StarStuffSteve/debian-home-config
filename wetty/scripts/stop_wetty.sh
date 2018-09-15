#!/bin/bash

docker container ls
echo "Enter container ID"
read CID
docker container stop $CID
docker container prune -f 
