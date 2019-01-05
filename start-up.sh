#!/bin/sh

cd external-tools/
docker-compose up -d
  echo "Cassandra is unavailable - sleeping ..."
while ! nc -z 172.16.238.5 9042; do
  sleep 1
done
echo "Cassandra is up - executing command."
cd ..

cd provisioner-ms-scripts/
docker build -q -t provisioner:latest .
docker run -d --name provisioner-ms --env eureka.instance.hostname=172.16.238.2 --env ribbon.listOfServers=172.16.238.2:9090 \
  --env eureka.client.serviceUrl.defaultZone=http://172.16.238.2:8761/eureka --env activemq.brokerUrl=tcp://172.16.238.3:61616 \
  --env cassandra.contactPoints=172.16.238.5:9042 --env mariadb.host=172.16.238.4 --network externaltools_app_net \
  --ip 172.16.238.6 provisioner:latest
cd ..

echo "Generating RSA keys..."
while ! docker exec -it provisioner-ms grep -q "provisioner-logger" logs/provisioner.log; do
  sleep 1
done

docker exec -it provisioner-ms sed -n -e 's/.*provisioner-logger - system.publicKey.//p' logs/provisioner.log | \
  sed -e 's/^[ \t]*//' | awk '{print $1"="$2}' | head -3 > .env
docker-compose up -d --build

echo "Successfully started fineract services."