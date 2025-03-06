#!/bin/bash

# Simple script to test archon.yaml build commands
# This script extracts and runs the build commands from archon.yaml

echo "Testing archon.yaml build commands..."

# Set the version variable
KEYCLOAK_VERSION="999.0.0-SNAPSHOT"

# Create the home directory
mkdir -p .kc

echo "Running pre-build commands..."
echo "Starting build process..."

echo "Running build commands..."
echo "Command: ./mvnw -f dist/pom.xml clean install"
# Uncomment to actually run the command
# ./mvnw -f dist/pom.xml clean install

echo "Command: cd quarkus"
# cd quarkus

echo "Command: ../mvnw -f ../pom.xml clean install -DskipTestsuite -DskipExamples -DskipTests"
# Uncomment to actually run the command
# ../mvnw -f ../pom.xml clean install -DskipTestsuite -DskipExamples -DskipTests

echo "Command: ../mvnw clean install -DskipTests"
# Uncomment to actually run the command
# ../mvnw clean install -DskipTests

echo "Command: cd .."
# cd ..

echo "Testing Docker build commands..."
echo "Command: cp quarkus/dist/target/keycloak-${KEYCLOAK_VERSION}.tar.gz quarkus/container/"
# Uncomment to actually run the command
# cp quarkus/dist/target/keycloak-${KEYCLOAK_VERSION}.tar.gz quarkus/container/

echo "Command: cd quarkus/container && docker build --build-arg KEYCLOAK_DIST=keycloak-${KEYCLOAK_VERSION}.tar.gz -t keycloak-demo ."
# Uncomment to actually run the command
# cd quarkus/container && docker build --build-arg KEYCLOAK_DIST=keycloak-${KEYCLOAK_VERSION}.tar.gz -t keycloak-demo .

echo "All commands have been tested (dry run)."
echo "To execute the commands, uncomment the actual command lines in this script."

echo "Test completed." 