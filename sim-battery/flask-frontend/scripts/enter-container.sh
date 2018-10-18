#!/bin/bash

LOCAL_IMG=$(docker images | grep $1 | grep aws | cut -d ' ' -f1)
#docker run -i -t --entrypoint /bin/zsh $LOCAL_IMG
docker run -i -t --entrypoint /bin/zsh $LOCAL_IMG
