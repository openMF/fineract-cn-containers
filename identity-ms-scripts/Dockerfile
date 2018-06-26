FROM openjdk:8-jdk-alpine

ARG identity_port=2021

ENV server.max-http-header-size=16384 \
    bonecp.partitionCount=1 \
    bonecp.maxConnectionsPerPartition=4 \
    bonecp.minConnectionsPerPartition=1 \
    bonecp.acquireIncrement=1 \
    cassandra.clusterName="Test Cluster" \
    cassandra.contactPoints=172.16.238.5:9042 \
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
    spring.cloud.config.enabled=false \
    spring.cloud.config.enabled=false \
    flyway.enabled=false \
    feign.hystrix.enabled=false \
    ribbon.eureka.enabled=false \
    ribbon.listOfServers=172.16.238.2:9090 \
    eureka.client.serviceUrl.defaultZone=http://172.16.238.2:8761/eureka/ \
    spring.cloud.discovery.enabled=true \
    eureka.instance.hostname=172.16.238.2 \
    eureka.client.fetchRegistry=true \
    eureka.registration.enabled=false \
    eureka.instance.leaseRenewalIntervalInSeconds=1 \
    eureka.client.instanceInfoReplicationIntervalSeconds=1 \
    activemq.brokerUrl=http://172.16.238.3:61616/ \
    ribbon.eureka.enabled=true \
    system.initialclientid=service-runner \
    spring.profiles.active=production

WORKDIR /tmp
COPY identity-service-boot-0.1.0-BUILD-SNAPSHOT.jar .
ENV spring.application.name="identity-v1" \
    server.port=$identity_port \
    server.contextPath="/identity-v1"

CMD ["java", "-jar", "identity-service-boot-0.1.0-BUILD-SNAPSHOT.jar"]
