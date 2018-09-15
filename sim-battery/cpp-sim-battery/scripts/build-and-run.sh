#!/bin/bash

./scripts/build-image.sh $2
echo "--- --- --- ---"
echo "--> Running <--"
echo "--- --- --- ---"
./scripts/run-container-on-port.sh $1 $2
