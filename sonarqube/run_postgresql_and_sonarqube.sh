#!/bin/sh

docker run --name sonar-postgres \
-e POSTGRES_USER=sonar \
-e POSTGRES_PASSWORD=secret \
-d postgres

docker run -d --name sonarqube_6 \
--link sonar-postgres:pgsonar \
-p 9000:9000 \
-p 9002:9002 \
-e SONARQUBE_JDBC_USERNAME=sonar \
-e SONARQUBE_JDBC_PASSWORD=secret \
-e SONARQUBE_JDBC_URL=jdbc:postgresql://pgsonar:5432/sonar \
sonarqube:6.0