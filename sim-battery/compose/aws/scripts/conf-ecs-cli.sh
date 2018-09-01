#!/bin/bash

cluster_name=$1
ACCESS_KEY_ID=$2
SECRET_ACCESS_KEY=$3

ecs-cli configure --cluster $cluster_name \
                  --region eu-central-1 \
                  --config-name $cluster_name \
                  --default-launch-type EC2 \
  && \
  ecs-cli configure profile --profile-name demo-profile \
                            --access-key $ACCESS_KEY_ID \
                            --secret-key $SECRET_ACCESS_KEY

