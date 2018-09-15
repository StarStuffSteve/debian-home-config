#!/bin/bash

URI=$(grep "repositoryUri" ./ecr/$1.ecr | cut -d '"' -f4)

echo $1
echo "--> to -->"
echo $URI

read -p "Are you sure? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
  docker tag $1:latest $URI

  aws ecr get-login --no-include-email > ./ecr/$1.ecr.login
  chmod a+x ./ecr/$1.ecr.login
  ./ecr/$1.ecr.login

  docker push $URI
fi
