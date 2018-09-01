#!/bin/bash

REGION=eu-central-1
ROLE=ecsInstanceRole
PROFILE=ecsInstanceProfile

aws iam create-instance-profile \
  --instance-profile-name $PROFILE \
  && \
  aws iam --region $REGION \
        create-role \
        --role-name $ROLE \
        --assume-role-policy-document file://ecs/ecs-instance-assume-role.json \
  && \
  aws iam --region $REGION \
        attach-role-policy \
        --role-name $ROLE \
        --policy-arn arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role \
  && \
  aws iam add-role-to-instance-profile \
          --role-name $ROLE \
          --instance-profile-name $PROFILE \
  aws iam list-instance-profiles | tee ./ecs/list-instance-profiles.out
