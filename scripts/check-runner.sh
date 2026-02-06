#!/bin/bash

# GitHub Actions Self-Hosted Runner - Health Check Script
# This script verifies that everything is properly configured for local deployments

echo "🔍 GitHub Actions Self-Hosted Runner - Health Check"
echo "======================================================"
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counters
PASSED=0
FAILED=0

# Function to test a command
check_command() {
    local cmd=$1
    local name=$2

    if command -v "$cmd" &> /dev/null; then
        VERSION=$("$cmd" --version 2>&1 | head -n 1)
        echo -e "${GREEN}✅${NC} $name: $VERSION"
        ((PASSED++))
    else
        echo -e "${RED}❌${NC} $name: NOT FOUND"
        ((FAILED++))
    fi
}

# Function to test a file or folder
check_file() {
    local path=$1
    local name=$2

    if [ -e "$path" ]; then
        echo -e "${GREEN}✅${NC} $name: $path"
        ((PASSED++))
    else
        echo -e "${RED}❌${NC} $name: NOT FOUND at $path"
        ((FAILED++))
    fi
}

# System tests
echo "📋 System Requirements:"
check_command "docker" "Docker"
check_command "docker-compose" "Docker Compose"
check_command "bash" "Bash"
check_command "git" "Git"

echo ""
echo "📂 Project Structure:"
check_file "$(pwd)/scripts/deploy-dev.sh" "Deploy DEV script"
check_file "$(pwd)/scripts/deploy-qa.sh" "Deploy QA script"
check_file "$(pwd)/docker-compose-dev.yml" "Docker Compose DEV"
check_file "$(pwd)/docker-compose-qa.yml" "Docker Compose QA"
check_file "$(pwd)/Dockerfile" "Dockerfile"

echo ""
echo "🐳 Docker Status:"

if docker ps &> /dev/null; then
    echo -e "${GREEN}✅${NC} Docker is running"
    ((PASSED++))
else
    echo -e "${RED}❌${NC} Docker is NOT running"
    ((FAILED++))
fi

# Check script permissions
echo ""
echo "🔐 Script Permissions:"
if [ -x "$(pwd)/scripts/deploy-dev.sh" ]; then
    echo -e "${GREEN}✅${NC} deploy-dev.sh is executable"
    ((PASSED++))
else
    echo -e "${YELLOW}⚠️${NC} deploy-dev.sh is NOT executable (will fix)"
    chmod +x "$(pwd)/scripts/deploy-dev.sh"
fi

if [ -x "$(pwd)/scripts/deploy-qa.sh" ]; then
    echo -e "${GREEN}✅${NC} deploy-qa.sh is executable"
    ((PASSED++))
else
    echo -e "${YELLOW}⚠️${NC} deploy-qa.sh is NOT executable (will fix)"
    chmod +x "$(pwd)/scripts/deploy-qa.sh"
fi

# Check Docker images
echo ""
echo "🐳 Docker Images:"
if docker images | grep -q "demo-pipeline"; then
    echo -e "${GREEN}✅${NC} demo-pipeline image exists"
    ((PASSED++))
else
    echo -e "${YELLOW}⚠️${NC} demo-pipeline image not found (will be built on deployment)"
fi

# Summary
echo ""
echo "======================================================"
echo "📊 Health Check Summary:"
echo -e "${GREEN}Passed: $PASSED${NC}"
echo -e "${RED}Failed: $FAILED${NC}"
echo "======================================================"

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ All checks passed! Ready for deployment.${NC}"
    exit 0
else
    echo -e "${YELLOW}⚠️ Some checks failed. Please fix the issues above.${NC}"
    exit 1
fi
