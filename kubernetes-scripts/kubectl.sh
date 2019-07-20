#!/bin/sh

cd kubernetes-scripts
echo "Starting ActiveMQ, Eureka, Maria DB and Cassandra ..."
kubectl apply -f activemq.yml
kubectl apply -f eureka.yml
kubectl apply -f mariadb.yml
kubectl apply -f cassandra.yml

cassandra_ip=""
mariadb_ip=""
eureka_ip=""
activemq_ip=""

echo ""
echo "Sharing Cassandra, MariaDB, Eureka and Active<Q  IP addresses..."
while [[ ${#cassandra_ip} -eq 0 || ${#mariadb_ip} -eq 0 || ${#eureka_ip} -eq 0 || ${#activemq_ip} -eq 0 ]] ; do
     cassandra_ip=$(kubectl describe service cassandra-cluster | grep 'LoadBalancer Ingress' \
          | grep -Eo '[0-9.]*')
     mariadb_ip=$(kubectl describe service mariadb-cluster | grep 'LoadBalancer Ingress'\
          | grep -Eo '[0-9.]*')
     eureka_ip=$(kubectl describe service eureka-cluster | grep 'LoadBalancer Ingress'\
          | grep -Eo '[0-9.]*')
     activemq_ip=$(kubectl describe service activemq-cluster | grep 'LoadBalancer Ingress'\
          | grep -Eo '[0-9.]*')
done

kubectl create configmap my-config --from-literal=eureka-ip=${eureka_ip} \
    --from-literal=ribbon-config=${eureka_ip}:9090 \
    --from-literal=eureka-default=http://${eureka_ip}:8761/eureka \
    --from-literal=mariadb-ip=${mariadb_ip} \
    --from-literal=activemq-ip=tcp://${activemq_ip}:61616 \
    --from-literal=cassandra-ip=${cassandra_ip}:9042

echo ""
echo "Starting Fineract services..."
kubectl apply -f provisioner.yml
provisioner_pod=$(kubectl get pod -l app=provisioner-ms -o jsonpath="{.items[0].metadata.name}")
while ! kubectl exec ${provisioner_pod} -- grep -q "provisioner-logger" logs/provisioner.log; do
  sleep 1
done
config_param=$(kubectl exec ${provisioner_pod} -- sed -n -e 's/.*provisioner-logger - system.publicKey.//p' logs/provisioner.log | \
  sed -e 's/^[ \t]*//' | awk '{print "--from-literal="$1"="$2}' | head -3)
kubectl create configmap secret-config ${config_param}
kubectl apply -f identity.yml
kubectl apply -f rhythm.yml
kubectl apply -f office.yml
kubectl apply -f customer.yml
kubectl apply -f portfolio.yml
kubectl apply -f ledger.yml