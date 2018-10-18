#!/bin/bash

ecs-cli compose --project-name demo \
                --cluster-config demo-cluster \
                service up \
  && \
  ecs-cli compose --project-name demo \
                  --cluster-config demo-cluster \
                  service ps
