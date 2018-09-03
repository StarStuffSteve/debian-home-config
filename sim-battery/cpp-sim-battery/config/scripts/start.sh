#!/bin/bash

# Start redis server
nohup redis-server /etc/redis/redis.conf &
echo "Redis server started"
sleep 1
# Run simulator
./RunSimulation
