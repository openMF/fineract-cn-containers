#!/bin/sh
docker-compose down --remove-orphans
cd external-tools/
docker-compose down
cd ..
