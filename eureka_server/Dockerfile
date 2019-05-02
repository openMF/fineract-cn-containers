FROM openjdk:8-jdk-alpine
RUN apk add --update \
    curl \
    && rm -rf /var/cache/apk/*
WORKDIR /tmp
COPY eureka_server-0.0.1-SNAPSHOT.jar .
CMD ["java", "-jar", "eureka_server-0.0.1-SNAPSHOT.jar"]