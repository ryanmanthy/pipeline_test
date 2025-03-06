#!/bin/bash

# Script to execute build steps from archon.yaml
# This script parses and executes the build commands from archon.yaml

echo "Executing build steps from archon.yaml..."

# Check if the file exists
if [ ! -f "archon.yaml" ]; then
  echo "Error: archon.yaml file not found!"
  exit 1
fi

# Extract and set the version variable
KEYCLOAK_VERSION=$(grep "KEYCLOAK_VERSION:" archon.yaml | cut -d '"' -f 2)
echo "Using Keycloak version: $KEYCLOAK_VERSION"

# Function to execute a command and check its result
execute_command() {
  local cmd="$1"
  echo "Executing: $cmd"
  eval "$cmd"
  local status=$?
  if [ $status -ne 0 ]; then
    echo "Error: Command failed with status $status"
    echo "Command was: $cmd"
    return $status
  fi
  return 0
}

# Execute pre-build commands
echo "Running pre-build commands..."
execute_command "mkdir -p .kc"

# Ask user which steps to execute
echo ""
echo "Which steps would you like to execute?"
echo "1. Build Keycloak"
echo "2. Build Docker image"
echo "3. Run Keycloak in development mode"
echo "4. Run Keycloak in production mode"
echo "5. All of the above"
echo "0. Exit"
read -p "Enter your choice (0-5): " choice

case $choice in
  1|5)
    # Execute build commands
    echo "Running build commands..."
    execute_command "./mvnw -f dist/pom.xml clean install" || exit 1
    execute_command "cd quarkus" || exit 1
    execute_command "../mvnw -f ../pom.xml clean install -DskipTestsuite -DskipExamples -DskipTests" || exit 1
    execute_command "../mvnw clean install -DskipTests" || exit 1
    execute_command "cd .." || exit 1
    ;;
  *)
    if [ "$choice" != "2" ] && [ "$choice" != "3" ] && [ "$choice" != "4" ] && [ "$choice" != "5" ]; then
      echo "Skipping build steps."
    fi
    ;;
esac

case $choice in
  2|5)
    # Execute Docker build commands
    echo "Building Docker image..."
    # First check if container directory exists
    if [ ! -d "quarkus/container" ]; then
      echo "Error: Container directory not found at quarkus/container"
      exit 1
    fi
    
    # Check if Dockerfile exists
    if [ ! -f "quarkus/container/Dockerfile" ]; then
      echo "Error: Dockerfile not found at quarkus/container/Dockerfile"
      exit 1
    fi
    
    # Copy the tar.gz file to the container directory
    execute_command "cp quarkus/dist/target/keycloak-${KEYCLOAK_VERSION}.tar.gz quarkus/container/" || exit 1
    
    # Build the Docker image from the container directory
    execute_command "cd quarkus/container && docker build --build-arg KEYCLOAK_DIST=keycloak-${KEYCLOAK_VERSION}.tar.gz -t keycloak-demo ." || exit 1
    execute_command "cd ../.." || exit 1
    ;;
  *)
    if [ "$choice" != "3" ] && [ "$choice" != "4" ] && [ "$choice" != "5" ]; then
      echo "Skipping Docker build steps."
    fi
    ;;
esac

case $choice in
  3|5)
    # Run in development mode
    echo "Running Keycloak in development mode..."
    execute_command "docker run -p 8080:8080 -p 8443:8443 -e KC_DB=dev-file -e KC_HTTP_ENABLED=true -e KC_HEALTH_ENABLED=true -e KC_METRICS_ENABLED=true -e KC_FEATURES=preview keycloak-demo start-dev"
    ;;
  4|5)
    # Run in production mode
    echo "Running Keycloak in production mode..."
    execute_command "docker run -p 8443:8443 -e KC_DB=postgres -e KC_DB_URL=jdbc:postgresql://postgres:5432/keycloak -e KC_DB_USERNAME=keycloak -e KC_DB_PASSWORD=password -e KC_HOSTNAME=localhost -e KC_HTTPS_REQUIRED=all keycloak-demo start"
    ;;
  *)
    if [ "$choice" != "0" ]; then
      echo "Skipping run steps."
    fi
    ;;
esac

if [ "$choice" == "0" ]; then
  echo "Exiting without executing any steps."
else
  echo "Execution completed."
fi 