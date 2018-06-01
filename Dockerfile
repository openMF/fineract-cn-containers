FROM openjdk:8-jdk-alpine

ARG provisioner_port=2020
ARG identity_port=2021
ARG rhythm_port=2022
ARG office_port=2023
ARG customer_port=2024
ARG portfolio_port=2025
ARG deposit-account-management_port=2026
ARG teller_port=2027
ARG reporting_port=2028
ARG payroll_port=2029


ENV server.max-http-header-size=16384 \
    bonecp.partitionCount=1 \
    bonecp.maxConnectionsPerPartition=4 \
    bonecp.minConnectionsPerPartition=1 \
    bonecp.acquireIncrement=1 \
    \
    #Call setAdditionalProperties()
    \
    #spring.application.name="springApplicationName" \
    server.port=9090 \
    cassandra.clusterName="Test Cluster" \
    cassandra.contactPoints=127.0.0.1:9142 \
    cassandra.keyspace=seshat \
    cassandra.cl.read=ONE \
    cassandra.cl.write=ONE \
    cassandra.cl.delete=ONE \
    mariadb.driverClass=org.mariadb.jdbc.Driver \
    mariadb.database=seshat \
    mariadb.host=localhost \
    mariadb.port=3306 \
    mariadb.user=root \
    mariadb.password=mysql \
    spring.cloud.discovery.enabled=false \
    spring.cloud.config.enabled=false \
    flyway.enabled=false \
    feign.hystrix.enabled=false \
    ribbon.eureka.enabled=false \
    ribbon.listOfServers=localhost:9090 \
    #this.keyPairHolder = RsaKeyPairFactory.createKeyPair();
    #system.publicKey.timestamp="this.keyPairHolder.getTimestamp()" \
    #system.publicKey.modulus="this.keyPairHolder.publicKey().getModulus().toString()" \
    #system.publicKey.exponent="this.keyPairHolder.publicKey().getPublicExponent().toString())" \
    \
    #server.port="integrationTestEnvironment.getFreshPort().toString()" \
    #setKeyPair
    eureka.client.serviceUrl.defaultZone=http://localhost:8761/eureka \
    spring.cloud.discovery.enabled=true \
    eureka.instance.hostname=localhost \
    eureka.client.fetchRegistry=true \
    eureka.registration.enabled=true \
    eureka.instance.leaseRenewalIntervalInSeconds=1 \
    initialInstanceInfoReplicationIntervalSeconds=0 \
    eureka.client.instanceInfoReplicationIntervalSeconds=1 \
    activemq.brokerUrl=tcp://localhost:61616 \
    ribbon.eureka.enabled=true \
    \
    ribbon.eureka.enabled=true \
    #this.keyPairHolder = RsaKeyPairFactory.createKeyPair();
    #system.publicKey.timestamp="this.keyPairHolder.getTimestamp()" \
    #system.publicKey.modulus="this.keyPairHolder.publicKey().getModulus().toString()" \
    #system.publicKey.exponent="this.keyPairHolder.publicKey().getPublicExponent().toString()" \
    \
    #For provision ms
    system.initialclientid=service-runner

WORKDIR /tmp
COPY jar_files .
COPY wait_for_db.sh .
RUN chmod +x wait_for_db.sh
ENV spring.application.name="customer-v1" server.port=$customer_port \
    server.contextPath="/customer-v1"
CMD sh './wait_for_db.sh' 0.0.0.0 9042 echo me
#CMD ["java", "-jar", "customer-service-boot-0.1.0-BUILD-SNAPSHOT.jar"]

