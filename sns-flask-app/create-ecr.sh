#!/bin/bash

aws ecr create-repository --repository-name $1 > $1.ecr
