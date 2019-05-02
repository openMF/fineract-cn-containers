#!/bin/sh

echo "Create service network"
docker network create --driver=bridge --subnet=172.16.238.0/24 externaltools_app_net

cd external-tools/
docker-compose up -d
echo "Cassandra is unavailable - sleeping ..."
while ! nc -z 172.16.238.5 9042; do
  sleep 1
done
echo "Cassandra is up - executing command."
cd ..

cd fineract-cn-server-provisioner
./gradlew clean build
java -jar build/libs/server-provisioner-0.1.0-BUILD-SNAPSHOT.jar
sed -n -e 's/.*test-logger - system.//p' logs/server-provisioner.log | \
  sed -e 's/^[ \t]*//' | awk '{print $1"="$2}' | head -5 > ../.env
rm -rf logs
cd ..

docker-compose up -d

echo "Successfully started fineract services."