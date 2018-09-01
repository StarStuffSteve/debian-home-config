#!/bin/bash

ecs-cli compose --project-name demo \
                --cluster-config demo-cluster \
                down \
  && \
  ecs-cli compose --project-name demo \
                  --cluster-config demo-cluster \
                  service rm
