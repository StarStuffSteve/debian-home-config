#!/bin/bash

cp -r /root/StarStuffSteve/flask-apps/sns/* ./code
docker build -f sns-flask-app -t sns-flask-app:latest .
