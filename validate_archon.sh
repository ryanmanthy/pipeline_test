#!/bin/bash

# Script to validate archon.yaml structure
# This script checks if the required sections exist in the YAML file

echo "Validating archon.yaml structure..."

# Check if the file exists
if [ ! -f "archon.yaml" ]; then
  echo "Error: archon.yaml file not found!"
  exit 1
fi

# Function to check if a section exists in the YAML file
check_section() {
  local section=$1
  local count=$(grep -c "^$section:" archon.yaml)
  
  if [ $count -eq 0 ]; then
    echo "Warning: '$section' section not found in archon.yaml"
    return 1
  else
    echo "✓ '$section' section found"
    return 0
  fi
}

# Check for required sections
check_section "variables"
check_section "project"
check_section "paths"
check_section "dependencies"
check_section "environment"
check_section "build"
check_section "docker_environments"

# Check for version variable
if grep -q "KEYCLOAK_VERSION:" archon.yaml; then
  echo "✓ 'KEYCLOAK_VERSION' variable found"
else
  echo "Warning: 'KEYCLOAK_VERSION' variable not found"
fi

# Check for variable usage
if grep -q "\${KEYCLOAK_VERSION}" archon.yaml; then
  echo "✓ 'KEYCLOAK_VERSION' variable is being used"
else
  echo "Warning: 'KEYCLOAK_VERSION' variable is defined but not used"
fi

# Check for build commands
if grep -A 20 "build:" archon.yaml | grep -q "mvnw"; then
  echo "✓ Build commands found"
else
  echo "Warning: No Maven build commands found in the build section"
fi

# Check for Docker build instructions
if grep -q "docker build" archon.yaml; then
  echo "✓ Docker build command found"
else
  echo "Warning: No Docker build command found"
fi

echo "Validation completed." 