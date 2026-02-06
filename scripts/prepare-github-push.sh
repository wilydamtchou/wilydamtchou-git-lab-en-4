#!/bin/bash

# GitHub Push Preparation Script
# This script prepares your project for pushing to GitHub

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║         GitHub Push Preparation Script                       ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# Check git is initialized
if [ ! -d .git ]; then
    echo -e "${RED}❌ Git repository not initialized${NC}"
    echo "Run: git init"
    exit 1
fi

echo -e "${BLUE}📋 Cleaning up before push:${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Remove actions-runner if it exists
if [ -d actions-runner/ ]; then
    echo -e "${YELLOW}Removing actions-runner/...${NC}"
    git rm -r --cached actions-runner/ 2>/dev/null || true
    rm -rf actions-runner/
    echo -e "${GREEN}✅ actions-runner/ removed${NC}"
fi

# Remove target directory if it exists
if [ -d target/ ]; then
    echo -e "${YELLOW}Removing target/...${NC}"
    git rm -r --cached target/ 2>/dev/null || true
    rm -rf target/
    echo -e "${GREEN}✅ target/ removed${NC}"
fi

# Remove .idea if it exists
if [ -d .idea/ ]; then
    echo -e "${YELLOW}Removing .idea/...${NC}"
    git rm -r --cached .idea/ 2>/dev/null || true
    rm -rf .idea/
    echo -e "${GREEN}✅ .idea/ removed${NC}"
fi

echo ""
echo -e "${BLUE}📦 Project statistics:${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "Total project size: $(du -sh . | awk '{print $1}')"
echo ""

# Count files by type
echo -e "${BLUE}📊 Files to be pushed:${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Java files:          $(find src -name "*.java" 2>/dev/null | wc -l)"
echo "YAML files:          $(find .github -name "*.yml" 2>/dev/null | wc -l)"
echo "Markdown files:      $(find . -maxdepth 1 -name "*.md" 2>/dev/null | wc -l)"
echo "Shell scripts:       $(find scripts -name "*.sh" 2>/dev/null | wc -l)"
echo "Configuration files: $(find . -maxdepth 1 -name "*.json" -o -name "*.xml" -o -name "*.properties" 2>/dev/null | wc -l)"
echo ""

# Check for large files
echo -e "${BLUE}🔍 Checking for large files:${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
LARGE_FILES=$(find . -type f -size +10M -not -path "./.git/*" 2>/dev/null)
if [ -z "$LARGE_FILES" ]; then
    echo -e "${GREEN}✅ No large files found (>10MB)${NC}"
else
    echo -e "${YELLOW}⚠️  Large files found:${NC}"
    echo "$LARGE_FILES"
fi

echo ""
echo -e "${BLUE}✅ Cleanup complete!${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Next steps:"
echo "1. Review changes: git status"
echo "2. Add files:     git add ."
echo "3. Commit:        git commit -m 'Initial GitHub Actions setup'"
echo "4. Add remote:    git remote add origin https://github.com/USERNAME/REPO.git"
echo "5. Push:          git push -u origin main"
echo ""
echo -e "${GREEN}Ready to push to GitHub! 🚀${NC}"
echo ""
