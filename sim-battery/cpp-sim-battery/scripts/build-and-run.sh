#!/bin/bash

docker build -f $1 -t $1 .
echo "--- --- --- ---"
echo "--> Running <--"
echo "--- --- --- ---"
docker run $1
