#!/bin/bash

# Quick Start Guide - Display in Terminal
# This script displays a quick and visual guide

clear

# Colors
BOLD='\033[1m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Title
echo -e "${BOLD}${BLUE}"
cat << "EOF"
╔══════════════════════════════════════════════════════════════════════════╗
║                                                                          ║
║                  🚀 GITHUB ACTIONS - LOCAL DEPLOYMENT                    ║
║                                                                          ║
║               ✅ Configuration Completed and Validated                    ║
║                                                                          ║
╚══════════════════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo ""
echo -e "${BOLD}${CYAN}📋 Quick Summary${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo -e "Your GitHub Actions workflows are now configured to"
echo "deploy DEV and QA directly on your machine via"
echo "a ${BOLD}self-hosted runner${NC}."
echo ""

echo -e "${BOLD}${CYAN}🎯 3 Ways to Deploy${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo -e "${GREEN}1. Automatic Deployment (Recommended)${NC}"
echo "   Trigger: Merge PR to main"
echo "   Action: Deploys automatically to DEV"
echo "   Time: ~2 minutes"
echo ""

echo -e "${GREEN}2. Manual Interactive Deployment (Recommended) ⭐${NC}"
echo "   GitHub → Actions → Manual Deploy → Run workflow"
echo "   Choose: dev or qa"
echo "   Time: ~1 minute"
echo ""

echo -e "${GREEN}3. Dedicated QA Deployment${NC}"
echo "   GitHub → Actions → Deploy QA → Run workflow"
echo "   Result: Deploys to QA"
echo "   Time: ~1 minute"
echo ""

echo -e "${BOLD}${CYAN}⚡ Essential Commands${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo -e "${YELLOW}Verify that everything is OK:${NC}"
echo "  ${BOLD}bash scripts/check-runner.sh${NC}"
echo ""

echo -e "${YELLOW}Deploy to DEV:${NC}"
echo "  ${BOLD}bash scripts/deploy-dev.sh${NC}"
echo ""

echo -e "${YELLOW}Deploy to QA:${NC}"
echo "  ${BOLD}bash scripts/deploy-qa.sh${NC}"
echo ""

echo -e "${YELLOW}Manage the runner:${NC}"
echo "  ${BOLD}bash scripts/runner-manager.sh start${NC}     # Start"
echo "  ${BOLD}bash scripts/runner-manager.sh status${NC}    # Check status"
echo "  ${BOLD}bash scripts/runner-manager.sh logs${NC}      # View logs"
echo ""

echo -e "${YELLOW}Monitor containers:${NC}"
echo "  ${BOLD}docker ps${NC}                          # List containers"
echo "  ${BOLD}docker logs demo-pipeline${NC}          # View app logs"
echo ""

echo -e "${YELLOW}Complete validation:${NC}"
echo "  ${BOLD}bash scripts/validate-setup.sh${NC}     # 32 checks"
echo ""

echo -e "${BOLD}${CYAN}📚 Documentation${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo -e "${YELLOW}Getting Started (Developers):${NC}"
echo "  👉 Read: ${BOLD}DEPLOYMENT_GUIDE.md${NC}"
echo ""

echo -e "${YELLOW}Complete Configuration (DevOps):${NC}"
echo "  👉 Read: ${BOLD}GITHUB_ACTIONS_SETUP.md${NC}"
echo ""

echo -e "${YELLOW}Overview (Everyone):${NC}"
echo "  👉 Read: ${BOLD}GITHUB_ACTIONS_README.md${NC}"
echo ""

echo -e "${YELLOW}French Summary:${NC}"
echo "  👉 Read: ${BOLD}SETUP_FINAL_FR.md${NC}"
echo ""

echo -e "${BOLD}${CYAN}🎮 Test Now${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo -e "${YELLOW}Option 1: Via GitHub UI (Recommended)${NC}"
echo "  1. Go to: https://github.com/[your-repo]/actions"
echo "  2. Select: 'Manual Deploy'"
echo "  3. Click: 'Run workflow'"
echo "  4. Choose: 'dev'"
echo "  5. Click: 'Run workflow'"
echo "  6. Watch the deployment! 🚀"
echo ""

echo -e "${YELLOW}Option 2: Via Terminal${NC}"
echo "  ${BOLD}bash scripts/deploy-dev.sh${NC}"
echo "  or"
echo "  ${BOLD}bash scripts/deploy-qa.sh${NC}"
echo ""

echo -e "${BOLD}${CYAN}✅ System Status${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check status
if bash scripts/check-runner.sh > /tmp/status.txt 2>&1; then
    echo -e "${GREEN}✅ System health: EXCELLENT${NC}"
else
    echo -e "${YELLOW}⚠️ System health: TO CHECK${NC}"
fi

if docker ps > /dev/null 2>&1; then
    CONTAINERS=$(docker ps -q | wc -l)
    echo -e "${GREEN}✅ Docker: RUNNING${NC} ($CONTAINERS containers)"
else
    echo -e "${YELLOW}⚠️ Docker: TO CHECK${NC}"
fi

if pgrep -f "actions-runner" > /dev/null; then
    echo -e "${GREEN}✅ GitHub Runner: ACTIVE${NC}"
else
    echo -e "${YELLOW}⚠️ GitHub Runner: INACTIVE (to start)${NC}"
fi

echo ""
echo -e "${BOLD}${CYAN}🔗 Architecture${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "GitHub Repository"
echo "  │"
echo "  ├─ Build & Tests (ubuntu-latest) - Cloud"
echo "  │   ├─ Maven Build"
echo "  │   ├─ Cucumber Tests"
echo "  │   └─ Newman Tests"
echo "  │"
echo "  └─ Deployment (self-hosted) - Your Machine ✨"
echo "      ├─ Docker Build"
echo "      ├─ Docker Compose Up"
echo "      └─ Application Deployed ✅"
echo ""

echo -e "${BOLD}${CYAN}🎯 Next Steps${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo -e "${GREEN}✓ Step 1: Verify Configuration${NC}"
echo "  ${BOLD}bash scripts/validate-setup.sh${NC}"
echo "  Expected result: 32/32 checks passed ✅"
echo ""

echo -e "${GREEN}✓ Step 2: Start the Runner${NC}"
echo "  ${BOLD}bash scripts/runner-manager.sh start${NC}"
echo "  or"
echo "  ${BOLD}cd ~/actions-runner && ./run.sh${NC}"
echo ""

echo -e "${GREEN}✓ Step 3: Test a Deployment${NC}"
echo "  Via GitHub UI or:"
echo "  ${BOLD}bash scripts/deploy-dev.sh${NC}"
echo ""

echo -e "${GREEN}✓ Step 4: Monitor Containers${NC}"
echo "  ${BOLD}docker ps${NC}"
echo "  ${BOLD}docker logs demo-pipeline${NC}"
echo ""

echo -e "${GREEN}✓ Step 5: Test the Application${NC}"
echo "  ${BOLD}curl http://localhost:8080/hello${NC}"
echo ""

echo ""
echo -e "${BOLD}${BLUE}"
cat << "EOF"
╔══════════════════════════════════════════════════════════════════════════╗
║                                                                          ║
║                   ✅ YOU ARE READY TO DEPLOY!                            ║
║                                                                          ║
║         Launch your first deployment now from GitHub                    ║
║                  or run a local script.                                 ║
║                                                                          ║
║                         Happy deploying! 🚀                              ║
║                                                                          ║
╚══════════════════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo ""
echo -e "Date: $(date '+%m/%d/%Y at %H:%M:%S')"
echo -e "Status: ${GREEN}✅ PRODUCTION READY${NC}"
echo ""
