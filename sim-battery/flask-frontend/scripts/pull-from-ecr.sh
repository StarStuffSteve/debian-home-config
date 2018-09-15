#!/bin/bash

aws ecr describe-repositories --repository-name $1 > ./ecr/$1.ecr.describe-repo
aws ecr describe-images --repository-name $1 > ./ecr/$1.ecr.describe-images

URI=$(grep "repositoryUri"./ecr/$1.ecr.describe-repo | cut -d '"' -f4)

docker pull $URI:latest
