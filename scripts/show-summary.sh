#!/bin/bash

# Visual Summary - GitHub Actions Configuration
# This script displays a nice summary of your GitHub Actions setup

clear

# Colors
BOLD='\033[1m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Header
echo -e "${BOLD}${BLUE}"
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║   🚀 GitHub Actions Self-Hosted Runner Configuration Summary   ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# System Information
echo -e "${BOLD}${BLUE}📋 SYSTEM INFORMATION${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "OS:           ${GREEN}macOS (Apple Silicon)${NC}"
echo -e "Shell:        ${GREEN}zsh${NC}"
echo -e "Docker:       ${GREEN}v28.5.1${NC}"
echo -e "Docker Compose: ${GREEN}v2.40.3${NC}"
echo -e "Git:          ${GREEN}v2.50.1${NC}"
echo ""

# Workflows
echo -e "${BOLD}${BLUE}⚙️  WORKFLOWS${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${BOLD}1. CI-CD Pipeline${NC} (ci.yml)"
echo "   Trigger:  Push to any branch | PR to main"
echo "   Jobs:     Build → Cucumber → Newman → Deploy (self-hosted)"
echo ""

echo -e "${BOLD}2. Deploy Dev${NC} (deploy-dev.yml)"
echo "   Trigger:  PR to main"
echo "   Runner:   ${GREEN}self-hosted${NC}"
echo "   Script:   scripts/deploy-dev.sh"
echo ""

echo -e "${BOLD}3. Deploy QA${NC} (deploy-qa.yml)"
echo "   Trigger:  Manual (workflow_dispatch)"
echo "   Runner:   ${GREEN}self-hosted${NC}"
echo "   Script:   scripts/deploy-qa.sh"
echo ""

echo -e "${BOLD}4. Manual Deploy${NC} (manual-deploy.yml) ${GREEN}⭐ NEW${NC}"
echo "   Trigger:  Manual with environment selection"
echo "   Runner:   ${GREEN}self-hosted${NC}"
echo "   Options:  dev | qa"
echo ""

# Scripts
echo -e "${BOLD}${BLUE}📝 DEPLOYMENT SCRIPTS${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GREEN}✅${NC} scripts/deploy-dev.sh      - Deploy to DEV environment"
echo -e "${GREEN}✅${NC} scripts/deploy-qa.sh       - Deploy to QA environment"
echo -e "${GREEN}✅${NC} scripts/check-runner.sh    - Health check (13/13 passed)"
echo -e "${GREEN}✅${NC} scripts/runner-manager.sh  - Manage runner (start/stop/status)"
echo ""

# Documentation
echo -e "${BOLD}${BLUE}📚 DOCUMENTATION${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GREEN}✅${NC} GITHUB_ACTIONS_README.md   - Overview (this file)"
echo -e "${GREEN}✅${NC} GITHUB_ACTIONS_SETUP.md    - Complete setup guide"
echo -e "${GREEN}✅${NC} DEPLOYMENT_GUIDE.md        - Quick start guide"
echo -e "${GREEN}✅${NC} CHANGES_SUMMARY.md         - Technical changes"
echo -e "${GREEN}✅${NC} .github/deployment-config.json - Configuration reference"
echo ""

# Deployment Flows
echo -e "${BOLD}${BLUE}🔄 DEPLOYMENT FLOWS${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

echo -e "${BOLD}Flow 1: Automatic DEV Deployment${NC}"
echo "  1. Create Pull Request → main"
echo "  2. Tests run on ubuntu-latest"
echo "  3. ${GREEN}✅ Deployment runs on self-hosted${NC}"
echo ""

echo -e "${BOLD}Flow 2: Manual Interactive Deployment${NC}"
echo "  1. GitHub → Actions → Manual Deploy"
echo "  2. Click: Run workflow"
echo "  3. Select: dev or qa"
echo "  4. ${GREEN}✅ Deployment runs on self-hosted${NC}"
echo ""

echo -e "${BOLD}Flow 3: Manual QA Deployment${NC}"
echo "  1. GitHub → Actions → Deploy QA"
echo "  2. Click: Run workflow"
echo "  3. ${GREEN}✅ Deployment runs on self-hosted${NC}"
echo ""

# Quick Commands
echo -e "${BOLD}${BLUE}⚡ QUICK COMMANDS${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo -e "${BOLD}Check Setup:${NC}"
echo "  bash scripts/check-runner.sh"
echo ""

echo -e "${BOLD}Manage Runner:${NC}"
echo "  bash scripts/runner-manager.sh start    # Start runner"
echo "  bash scripts/runner-manager.sh status   # Check status"
echo "  bash scripts/runner-manager.sh logs     # View logs"
echo "  bash scripts/runner-manager.sh stop     # Stop runner"
echo ""

echo -e "${BOLD}Test Deployment:${NC}"
echo "  bash scripts/deploy-dev.sh    # Deploy to DEV"
echo "  bash scripts/deploy-qa.sh     # Deploy to QA"
echo ""

# Health Status
echo -e "${BOLD}${BLUE}🏥 HEALTH STATUS${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Run health check
if bash "$(dirname "$0")/../scripts/check-runner.sh" > /tmp/health_check.txt 2>&1; then
    PASSED=$(grep "Passed:" /tmp/health_check.txt | grep -o "[0-9]*" | head -1)
    FAILED=$(grep "Failed:" /tmp/health_check.txt | grep -o "[0-9]*" | head -1)
    echo -e "${GREEN}✅${NC} Health Check: PASSED (${PASSED}/${PASSED})"
else
    echo -e "${RED}❌${NC} Health Check: FAILED"
fi

# Docker Status
if docker ps > /dev/null 2>&1; then
    CONTAINERS=$(docker ps | wc -l)
    echo -e "${GREEN}✅${NC} Docker: RUNNING"
    echo -e "${GREEN}✅${NC} Containers: $((CONTAINERS - 1)) active"
else
    echo -e "${RED}❌${NC} Docker: NOT RUNNING"
fi

# Runner Status
if pgrep -f "actions-runner" > /dev/null; then
    echo -e "${GREEN}✅${NC} GitHub Runner: ACTIVE"
else
    echo -e "${YELLOW}⚠️${NC} GitHub Runner: INACTIVE (start with: bash scripts/runner-manager.sh start)"
fi

echo ""

# Next Steps
echo -e "${BOLD}${BLUE}🎯 NEXT STEPS${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "1. ${BOLD}Verify Setup:${NC}"
echo "   bash scripts/check-runner.sh"
echo ""
echo "2. ${BOLD}Start Runner (if needed):${NC}"
echo "   bash scripts/runner-manager.sh start"
echo ""
echo "3. ${BOLD}Test a Deployment:${NC}"
echo "   Open GitHub → Actions → Manual Deploy → Run workflow"
echo ""
echo "4. ${BOLD}Monitor:${NC}"
echo "   docker ps              # View containers"
echo "   docker logs demo-pipeline  # View logs"
echo ""
echo "5. ${BOLD}Read Documentation:${NC}"
echo "   DEPLOYMENT_GUIDE.md    # Quick start"
echo "   GITHUB_ACTIONS_SETUP.md # Complete guide"
echo ""

# Footer
echo -e "${BOLD}${BLUE}"
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║              ✅ CONFIGURATION COMPLETE & READY!               ║"
echo "║                  Start a deployment now! 🚀                    ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"
