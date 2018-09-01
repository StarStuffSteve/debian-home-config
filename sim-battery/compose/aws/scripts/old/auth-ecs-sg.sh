#!/bin/bash

SG_ID=$(grep 'Security Group' ./ecs/ecs-cli-up.out | cut -d ' ' -f4)

aws ec2 authorize-security-group-ingress \
    --group-id $SG_ID \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0
