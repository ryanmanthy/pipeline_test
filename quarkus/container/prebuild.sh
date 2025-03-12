#!/bin/bash
set -e
./mvnw -f dist/pom.xml clean install -DskipTestsuite -DskipExamples -DskipTests
cd quarkus
./mvnw -f ./pom.xml clean install -DskipTestsuite -DskipExamples -DskipTests
./mvnw clean install -DskipTests
cd ..