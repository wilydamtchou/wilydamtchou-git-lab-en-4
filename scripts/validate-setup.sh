#!/bin/bash

# Final Validation Script
# Verifies all changes have been applied correctly

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║          🔍 Final Validation - GitHub Actions Setup             ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

PASSED=0
FAILED=0

# Function to validate file
check_file_exists() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✅${NC} $2"
        ((PASSED++))
    else
        echo -e "${RED}❌${NC} $2 - NOT FOUND: $1"
        ((FAILED++))
    fi
}

# Function to validate content in file
check_file_content() {
    if grep -q "$2" "$1" 2>/dev/null; then
        echo -e "${GREEN}✅${NC} $3"
        ((PASSED++))
    else
        echo -e "${RED}❌${NC} $3 - PATTERN NOT FOUND"
        ((FAILED++))
    fi
}

# Function to validate script executable
check_executable() {
    if [ -x "$1" ]; then
        echo -e "${GREEN}✅${NC} $2 (executable)"
        ((PASSED++))
    else
        echo -e "${YELLOW}⚠️${NC} $2 (not executable - fixing...)"
        chmod +x "$1" 2>/dev/null
        if [ -x "$1" ]; then
            echo -e "${GREEN}✅${NC} $2 (now executable)"
            ((PASSED++))
        else
            echo -e "${RED}❌${NC} $2 (failed to make executable)"
            ((FAILED++))
        fi
    fi
}

echo -e "${BLUE}📋 Workflow Files:${NC}"
check_file_exists ".github/workflows/ci.yml" "ci.yml"
check_file_exists ".github/workflows/deploy-dev.yml" "deploy-dev.yml"
check_file_exists ".github/workflows/deploy-qa.yml" "deploy-qa.yml"
check_file_exists ".github/workflows/manual-deploy.yml" "manual-deploy.yml (NEW)"

echo ""
echo -e "${BLUE}🔍 Workflow Configuration:${NC}"
check_file_content ".github/workflows/ci.yml" "runs-on: self-hosted" "ci.yml uses self-hosted runner"
check_file_content ".github/workflows/deploy-dev.yml" "runs-on: self-hosted" "deploy-dev.yml uses self-hosted runner"
check_file_content ".github/workflows/deploy-qa.yml" "runs-on: self-hosted" "deploy-qa.yml uses self-hosted runner"
check_file_content ".github/workflows/manual-deploy.yml" "workflow_dispatch" "manual-deploy.yml has workflow_dispatch trigger"

echo ""
echo -e "${BLUE}📝 Deployment Scripts:${NC}"
check_file_exists "scripts/deploy-dev.sh" "deploy-dev.sh"
check_file_exists "scripts/deploy-qa.sh" "deploy-qa.sh"
check_executable "scripts/deploy-dev.sh" "deploy-dev.sh"
check_executable "scripts/deploy-qa.sh" "deploy-qa.sh"

echo ""
echo -e "${BLUE}🛠️ Utility Scripts:${NC}"
check_file_exists "scripts/check-runner.sh" "check-runner.sh"
check_executable "scripts/check-runner.sh" "check-runner.sh"
check_file_exists "scripts/runner-manager.sh" "runner-manager.sh"
check_executable "scripts/runner-manager.sh" "runner-manager.sh"
check_file_exists "scripts/show-summary.sh" "show-summary.sh"
check_executable "scripts/show-summary.sh" "show-summary.sh"

echo ""
echo -e "${BLUE}📚 Documentation Files:${NC}"
check_file_exists "GITHUB_ACTIONS_README.md" "GITHUB_ACTIONS_README.md"
check_file_exists "GITHUB_ACTIONS_SETUP.md" "GITHUB_ACTIONS_SETUP.md"
check_file_exists "DEPLOYMENT_GUIDE.md" "DEPLOYMENT_GUIDE.md"
check_file_exists "CHANGES_SUMMARY.md" "CHANGES_SUMMARY.md"
check_file_exists "FINAL_SUMMARY_FR.md" "FINAL_SUMMARY_FR.md"
check_file_exists "SETUP_COMPLETE.md" "SETUP_COMPLETE.md"
check_file_exists ".github/deployment-config.json" "deployment-config.json"

echo ""
echo -e "${BLUE}☕ Spring Boot Components:${NC}"
check_file_exists "src/main/java/com/example/demopipeline/DeploymentService.java" "DeploymentService.java"
check_file_exists "src/main/java/com/example/demopipeline/DeploymentController.java" "DeploymentController.java"
check_file_content "src/main/java/com/example/demopipeline/DeploymentController.java" "@PostMapping" "DeploymentController has REST endpoints"
check_file_content "src/main/java/com/example/demopipeline/DeploymentService.java" "executeDeployDevScript" "DeploymentService has deployment methods"

echo ""
echo -e "${BLUE}🔧 Configuration Validation:${NC}"

# Check if git is initialized
if [ -d ".git" ]; then
    echo -e "${GREEN}✅${NC} Git repository initialized"
    ((PASSED++))
else
    echo -e "${RED}❌${NC} Git repository not found"
    ((FAILED++))
fi

# Check Docker
if command -v docker &> /dev/null; then
    DOCKER_VERSION=$(docker --version)
    echo -e "${GREEN}✅${NC} Docker installed: $DOCKER_VERSION"
    ((PASSED++))
else
    echo -e "${RED}❌${NC} Docker not found"
    ((FAILED++))
fi

# Check Docker Compose
if command -v docker-compose &> /dev/null; then
    COMPOSE_VERSION=$(docker-compose --version)
    echo -e "${GREEN}✅${NC} Docker Compose installed: $COMPOSE_VERSION"
    ((PASSED++))
else
    echo -e "${RED}❌${NC} Docker Compose not found"
    ((FAILED++))
fi

echo ""
echo "════════════════════════════════════════════════════════════════"
echo -e "📊 ${BLUE}Validation Summary:${NC}"
echo -e "   ${GREEN}Passed: $PASSED${NC}"
echo -e "   ${RED}Failed: $FAILED${NC}"
echo "════════════════════════════════════════════════════════════════"

if [ $FAILED -eq 0 ]; then
    echo ""
    echo -e "${GREEN}${BOLD}✅ ALL CHECKS PASSED! Configuration is complete and ready.${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Push changes to GitHub:"
    echo "     git add ."
    echo "     git commit -m 'Configure GitHub Actions for local deployments'"
    echo "     git push origin main"
    echo ""
    echo "  2. Start the runner:"
    echo "     bash scripts/runner-manager.sh start"
    echo ""
    echo "  3. Test a deployment:"
    echo "     GitHub → Actions → Manual Deploy → Run workflow"
    echo ""
    exit 0
else
    echo ""
    echo -e "${YELLOW}⚠️ Some checks failed. Please review the errors above.${NC}"
    exit 1
fi
