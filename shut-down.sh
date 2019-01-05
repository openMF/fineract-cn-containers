#!/bin/sh
docker-compose down --remove-orphans
docker stop provisioner-ms
docker rm provisioner-ms
cd external-tools/
docker-compose down
cd ..
docker network rm externaltools_app_net