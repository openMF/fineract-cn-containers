#!/bin/sh

docker swarm init --advertise-addr 10.0.0.239

echo "Create service network"
docker network create --driver=overlay --subnet=172.16.238.0/24 --gateway=172.16.238.1 externaltools_app_net

#Swarm master IP
master_ip=docker network inspect -f '{{range .Peers}}{{.IP}}{{end}}' externaltools_app_net

cd external-tools/
docker stack deploy -c docker-compose.yml tools
echo "Cassandra is unavailable - sleeping ..."
while ! nc -z ${master_ip} 9042; do
  sleep 1
done
echo "Cassandra is up - executing command."
cd ..

echo "Generating RSA keys..."
docker service create --name provisioner-ms \
 --env eureka.instance.hostname=eureka \
 --env ribbon.listOfServers=eureka:9090 \
 --env eureka.client.serviceUrl.defaultZone=http://eureka:8761/eureka \
 --env activemq.brokerUrl=tcp://activemq:61616   \
 --env cassandra.contactPoints=cassandra:9042 \
 --env mariadb.host=mariadb \
 --replicas 3 \
 --network externaltools_app_net \
 --health-cmd 'curl -s -X POST -H "Content-Type: application/json" "http://localhost:2020/provisioner/v1/auth/token?grant_type=password&client_id=service-runner&username=wepemnefret&password=oS/0IiAME/2unkN1momDrhAdNKOhGykYFH/mJN20" >  /dev/null || exit 1'  \
 --health-interval 1m \
 --health-retries 5 \
 --restart-condition any \
 --restart-delay 10s \
 --restart-max-attempts 3 \
 anh3h/fineract-cn-provisioner:latest

# echo "Generating RSA keys..."
# provisioner_id = $( docker ps --filter label=com.docker.swarm.service.name=provisioner-ms --format={{.ID}} )
# while ! docker exec -it ${provisioner_id} grep -q "provisioner-logger" logs/provisioner.log; do
#   sleep 1
# done

# docker exec -it ${provisioner_id} sed -n -e 's/.*provisioner-logger - system.publicKey.//p' logs/provisioner.log | \
#   sed -e 's/^[ \t]*//' | awk '{print $1"="$2}' | head -3 > .env
# docker stack deploy -c docker-compose.yml fineracts

# echo "Successfully started fineract services."

#container health checks

#container IP address
# docker ps --filter label=com.docker.swarm.service.name=provisioner-ms --format={{.ID}}

