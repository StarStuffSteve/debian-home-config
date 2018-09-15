#!/bin/bash

docker container prune -f
docker image prune -f
docker build -t root/wetty .
