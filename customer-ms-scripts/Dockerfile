FROM openjdk:8-jdk-alpine

ARG customer_port=2024
ARG cassandraIp=172.16.238.5
ARG activemqIp=172.16.238.3
ARG eurekaIp=172.16.238.2

ENV server.max-http-header-size=16384 \
    bonecp.partitionCount=1 \
    bonecp.maxConnectionsPerPartition=4 \
    bonecp.minConnectionsPerPartition=1 \
    bonecp.acquireIncrement=1 \
    server.port=9090 \
    cassandra.clusterName="Test Cluster" \
    cassandra.contactPoints=$cassandraIp:9042 \
    cassandra.keyspace=seshat \
    cassandra.cl.read=ONE \
    cassandra.cl.write=ONE \
    cassandra.cl.delete=ONE \
    mariadb.driverClass=org.mariadb.jdbc.Driver \
    mariadb.database=seshat \
    mariadb.host=172.16.238.4 \
    mariadb.port=3306 \
    mariadb.user=root \
    mariadb.password=mysql \
    spring.cloud.discovery.enabled=false \
    spring.cloud.config.enabled=false \
    flyway.enabled=false \
    feign.hystrix.enabled=false \
    ribbon.eureka.enabled=false \
    ribbon.listOfServers=$eurekaIp:9090 \
    eureka.client.serviceUrl.defaultZone=http://$eurekaIp:8761/eureka \
    spring.cloud.discovery.enabled=true \
    eureka.instance.hostname=$eurekaIp \
    eureka.client.fetchRegistry=true \
    eureka.registration.enabled=false \
    eureka.instance.leaseRenewalIntervalInSeconds=1 \
    eureka.client.instanceInfoReplicationIntervalSeconds=1 \
    activemq.brokerUrl=tcp://$activemqIp:61616 \
    ribbon.eureka.enabled=true \
    system.initialclientid=service-runner \
    spring.profiles.active=production

WORKDIR /tmp
COPY customer-service-boot-0.1.0-BUILD-SNAPSHOT.jar .
ENV spring.application.name="customer-v1" \
    server.port=$customer_port \
    server.contextPath="/customer-v1"

CMD ["java", "-jar", "customer-service-boot-0.1.0-BUILD-SNAPSHOT.jar"]
