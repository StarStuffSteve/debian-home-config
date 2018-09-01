#!/bin/bash

mkdir -p ./ecr
aws ecr create-repository --repository-name $1 > ./ecr/$1.ecr
