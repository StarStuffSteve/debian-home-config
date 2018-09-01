#!/bin/bash

nohup redis-server /etc/redis/redis.conf &
echo "Redis server started"
sleep 1 
./RunSimulation
