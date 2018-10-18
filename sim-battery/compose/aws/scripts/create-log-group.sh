#!/bin/bash

mkdir -p ./ecs
aws logs create-log-group --log-group-name demo-log-group
sleep 1
aws logs describe-log-groups --log-group-name-prefix demo-log \
          > ./ecs/describe-log-groups.out
