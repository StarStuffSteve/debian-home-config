#!/bin/bash

#LOCAL_IMG=$(docker images | grep $1 | grep aws | cut -d ' ' -f1)
URI=$(grep "repositoryUri" $1.ecr | cut -d '"' -f4)

echo $1
echo "--> to -->"
echo $URI

read -p "Are you sure? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  docker tag $1:latest $URI

  aws ecr get-login --no-include-email > $1.ecr.login
  chmod a+x $1.ecr.login
  ./$1.ecr.login

  docker push $URI
fi
