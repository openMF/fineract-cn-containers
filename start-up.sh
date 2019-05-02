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

docker run -d --name provisioner-ms \
  --env eureka.instance.hostname=172.16.238.2 \
  --env ribbon.listOfServers=172.16.238.2:9090 \
  --env eureka.client.serviceUrl.defaultZone=http://172.16.238.2:8761/eureka \
  --env activemq.brokerUrl=tcp://activemq:61616 \
  --env cassandra.contactPoints=172.16.238.5:9042 \
  --env mariadb.host=172.16.238.4 \
  --health-cmd 'curl -s -X POST -H "Content-Type: application/json" "http://localhost:2020/provisioner/v1/auth/token?grant_type=password&client_id=service-runner&username=wepemnefret&password=oS/0IiAME/2unkN1momDrhAdNKOhGykYFH/mJN20" >  /dev/null || exit 1'  \
  --health-interval 1m \
  --health-retries 5 \
  --network externaltools_app_net \
  --ip 172.16.238.6 anh3h/fineract-cn-provisioner:latest

echo "Generating RSA keys..."
while ! docker exec -it provisioner-ms grep -q "provisioner-logger" logs/provisioner.log; do
  sleep 1
done

docker exec -it provisioner-ms sed -n -e 's/.*provisioner-logger - system.publicKey.//p' logs/provisioner.log | \
  sed -e 's/^[ \t]*//' | awk '{print $1"="$2}' | head -3 > .env
docker-compose up -d

echo "Successfully started fineract services."