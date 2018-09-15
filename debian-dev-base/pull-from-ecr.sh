#!/bin/bash

aws ecr describe-repositories --repository-name $1 > $1.ecr.describe-repo
aws ecr describe-images --repository-name $1 > $1.ecr.describe-images

URI=$(grep "repositoryUri" $1.ecr.describe-repo | cut -d '"' -f4)

docker pull $URI:latest
