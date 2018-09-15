#!/bin/bash

mkdir -p ecs
ecs-cli up --force \
        --capability-iam \
        --size 2 \
        --instance-type t2.medium \
        --cluster-config demo-cluster \
        | tee ./ecs/ecs-cli-up.out

#--instance-role ecsInstanceProfile \
