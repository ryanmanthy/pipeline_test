#!/bin/bash
apk add --no-cache openjdk21 maven
./mvnw clean install -DskipTestsuite -DskipExamples -DskipTests 
cd quarkus/container
cp ../dist/target/keycloak-999.0.0-SNAPSHOT.tar.gz .

