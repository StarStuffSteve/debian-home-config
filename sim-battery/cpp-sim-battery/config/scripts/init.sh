#!/bin/bash

# cpp, redis, build tools
apt update
apt install -y redis-server --fix-missing

# Configure redis
mkdir -p /etc/redis
mkdir -p /var/redis
adduser --system --group --no-create-home redis
chown redis:redis /var/redis
chown redis:redis /etc/redis
chmod 770 /var/redis
