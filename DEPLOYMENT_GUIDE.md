# 🚀 Quick Start - GitHub Actions Deployment Guide

## Summary of Changes

Your GitHub Actions pipeline has been configured to use a **self-hosted runner** to enable local deployments on your machine.

## Modified Files

### 1. **ci.yml** ✅
- ✅ Modified `deploy_dev` job: `runs-on: self-hosted`
- Automatically deploys to DEV when a commit is merged to `main`

### 2. **deploy-dev.yml** ✅
- ✅ Modified `deploy_dev` job: `runs-on: self-hosted`
- Triggered by Pull Requests to `main`

### 3. **deploy-qa.yml** ✅
- ✅ Modified `deploy_qa` job: `runs-on: self-hosted`
- Triggered manually via `workflow_dispatch`

### 4. **manual-deploy.yml** ⭐ NEW
- ✅ New workflow with interactive interface
- Allows choosing the environment (dev or qa)
- Accessible from GitHub Actions > "Manual Deploy"

## How to Use

### 🎯 Option 1: Automatic Deployment (DEV)

**Trigger**: Merge PR to `main`

```
1. Create a branch
2. Make your changes
3. Create a Pull Request to main
4. GitHub Actions runs the tests
5. ✅ DEV deployment runs automatically on your machine
```

### 🎯 Option 2: Manual Deployment (DEV or QA)

**Trigger**: Manual from GitHub

```
1. Go to: GitHub > Your Repo > Actions
2. Select "Manual Deploy"
3. Click "Run workflow"
4. Choose the environment:
   - dev
   - qa
5. Click "Run workflow"
6. ✅ Deployment runs on your machine
```

### 🎯 Option 3: Manual QA Deployment

**Trigger**: Manual from the dedicated workflow

```
1. Go to: GitHub > Your Repo > Actions
2. Select "Deploy QA"
3. Click "Run workflow"
4. ✅ QA deployment runs on your machine
```

## Architecture

```
┌─────────────────────────────────────────┐
│         GitHub Repository               │
│  (Code & Workflows)                     │
└────────────────────┬────────────────────┘
                     │
         ┌───────────┴───────────┐
         │                       │
    ┌────▼─────────┐   ┌────────▼────────┐
    │ ubuntu-latest│   │  self-hosted    │
    │              │   │  (Your Machine) │
    │ • Build      │   │                 │
    │ • Tests      │   │ • Deploy        │
    │ • Verify     │   │ • Docker        │
    └──────────────┘   │ • Containers    │
                       └─────────────────┘
```

## Runner Status

### ✅ Current Configuration

```
System: macOS (Apple Silicon)
Shell: zsh
Docker: v28.5.1 ✅
Docker Compose: v2.40.3 ✅
Git: v2.50.1 ✅
Runner Status: ✅ OPERATIONAL
```

### Check runner status:

```bash
# Check if the runner is active
cd ~/actions-runner
ps aux | grep actions-runner

# View logs
tail -f _diag/Runner_*.log

# Test the configuration
bash scripts/check-runner.sh
```

## Quick Troubleshooting

### ❌ Runner is not showing on GitHub

```bash
# Verify that the runner is active
ps aux | grep actions-runner

# Restart the runner
cd ~/actions-runner
./run.sh
```

### ❌ Docker is not accessible

```bash
# Verify that Docker is running
docker ps

# Check permissions
groups $USER | grep docker
```

### ❌ Deployment fails

```bash
# Run the script manually to debug
bash scripts/deploy-dev.sh
# or
bash scripts/deploy-qa.sh

# Check the workflow logs on GitHub
```

## Recommended Next Steps

1. ✅ **Test a manual deployment**
   - Go to Actions > Manual Deploy
   - Select "dev"
   - Verify that the container starts correctly

2. ✅ **Check the containers**
   ```bash
   docker ps  # View active containers
   docker logs demo-pipeline  # View logs
   ```

3. ✅ **Test the endpoints**
   ```bash
   curl http://localhost:8080/hello
   ```

4. ✅ **Configure notifications** (optional)
   - Add a Slack notification
   - Add an email action on failure

## Environment Variables (optional)

If you need to pass variables to the deployment, add them to:
- GitHub > Settings > Secrets and variables > Actions

Example:
```yaml
- name: Deploy with environment
  run: |
    export APP_ENV=dev
    bash ./scripts/deploy-dev.sh
```

## Final Summary

✅ **Your GitHub Actions workflows are now configured to:**
- ✅ Run tests on `ubuntu-latest`
- ✅ Launch deployments on your `self-hosted runner`
- ✅ Support DEV and QA deployments
- ✅ Allow manual deployments from GitHub

🎉 **You are ready to make local deployments from GitHub Actions!**

## Support

For more information:
- 📚 GitHub Actions Documentation: https://docs.github.com/en/actions
- 📚 Self-hosted Runners: https://docs.github.com/en/actions/hosting-your-own-runners
- 📚 Docker: https://docs.docker.com
- 📚 Docker Compose: https://docs.docker.com/compose
