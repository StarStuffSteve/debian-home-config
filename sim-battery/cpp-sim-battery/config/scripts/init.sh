#!/bin/bash

# cpp, redis, build tools
apt update
#apt install -y build-essential redis-server git cmake --fix-missing
apt install -y redis-server --fix-missing

# Configure redis
mkdir -p /etc/redis
mkdir -p /var/redis
adduser --system --group --no-create-home redis
chown redis:redis /var/redis
chown redis:redis /etc/redis
chmod 770 /var/redis

# Download and install latest cpp_redis
#mkdir cpp_redis
#git clone https://github.com/Cylix/cpp_redis.git cpp_redis
#cd cpp_redis
#git submodule init && git submodule update
#mkdir build
#cd build
#cmake .. -DCMAKE_BUILD_TYPE=Release
#make
#make install
