#!/bin/bash

REGION=eu-central-1
ROLE=ecsTaskExecutionRole

aws iam --region $REGION \
        create-role \
        --role-name $ROLE \
        --assume-role-policy-document file://ecs/task-execution-assume-role.json \
  && \
  aws iam --region $REGION \
        attach-role-policy \
        --role-name $ROLE \
        --policy-arn arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy
