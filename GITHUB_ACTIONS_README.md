# 🚀 GitHub Actions Local Deployment Setup

## 📌 What's New?

Your GitHub Actions pipeline has been fully configured to support **local deployments on your machine** using a self-hosted runner. This means you can now deploy your DEV and QA environments directly from GitHub Actions!

## ✨ Key Features

✅ **Automatic DEV Deployment** - Deploys automatically when code is merged to `main`  
✅ **Manual QA Deployment** - Trigger QA deployments on-demand from GitHub  
✅ **Interactive Deployment UI** - Choose environment (dev/qa) from GitHub Actions  
✅ **Health Check Script** - Verify your setup is correct  
✅ **Runner Manager** - Easy start/stop/status commands  
✅ **Complete Documentation** - Step-by-step guides and troubleshooting  

## 📂 What Changed?

### Modified Workflows
- `.github/workflows/ci.yml` - Deploy job now runs on `self-hosted` runner
- `.github/workflows/deploy-dev.yml` - Deploy job now runs on `self-hosted` runner
- `.github/workflows/deploy-qa.yml` - Deploy job now runs on `self-hosted` runner

### New Workflows
- `.github/workflows/manual-deploy.yml` ⭐ - Interactive deployment with environment selection

### New Scripts
- `scripts/check-runner.sh` - Health check for your setup
- `scripts/runner-manager.sh` - Manage runner start/stop/status

### New Documentation
- `GITHUB_ACTIONS_SETUP.md` - Complete setup guide
- `DEPLOYMENT_GUIDE.md` - Quick start guide for developers
- `CHANGES_SUMMARY.md` - Technical summary of changes
- `.github/deployment-config.json` - Configuration reference

## 🎯 Quick Start

### 1. Verify Everything is Ready
```bash
bash scripts/check-runner.sh
```

### 2. Start the Runner (if needed)
```bash
bash scripts/runner-manager.sh start
```

### 3. Test a Deployment

**Option A: Manual Deployment**
```
Go to: GitHub Actions > Manual Deploy > Run workflow
Select environment: dev or qa
Watch deployment on your machine
```

**Option B: Automatic Deployment**
```
Create a PR to main
All tests run in the cloud
Deployment runs on your machine
```

## 📊 How It Works

```
Your Machine (Self-Hosted Runner)
    ↑
    │ Receives job
    │ Executes deployment
    ↓
GitHub Actions
    ↑
    │ GitHub repository
    │ Workflows & triggers
    ↓
GitHub UI (Manual Trigger)
```

## 🔧 Available Commands

### Check Configuration
```bash
bash scripts/check-runner.sh
```
Shows system requirements, Docker status, permissions, etc.

### Manage Runner
```bash
# Start the runner
bash scripts/runner-manager.sh start

# Check status
bash scripts/runner-manager.sh status

# View logs
bash scripts/runner-manager.sh logs

# Stop the runner
bash scripts/runner-manager.sh stop

# Show diagnostics
bash scripts/runner-manager.sh diag
```

### Test Deployments
```bash
# Deploy to DEV manually
bash scripts/deploy-dev.sh

# Deploy to QA manually
bash scripts/deploy-qa.sh
```

## 📚 Documentation

| Document | Purpose |
|----------|---------|
| `GITHUB_ACTIONS_SETUP.md` | Complete configuration guide |
| `DEPLOYMENT_GUIDE.md` | Quick start for developers |
| `CHANGES_SUMMARY.md` | Technical details of changes |
| `GITHUB_ACTIONS_RUNNER_MANAGER.md` | Runner management guide |

## ✅ System Status

```
✅ Docker: v28.5.1 (Running)
✅ Docker Compose: v2.40.3
✅ Git: v2.50.1
✅ Bash: v3.2.57
✅ Project Structure: Ready
✅ Scripts: Executable
✅ Health Check: PASSED (13/13)
```

## 🚀 Deployment Workflows

### Workflow 1: Automatic DEV (on merge to main)
```
1. Create PR with code changes
2. GitHub tests run on ubuntu-latest
3. ✅ PR approved and merged to main
4. Deploy job runs on your machine
5. Docker containers start locally
```

### Workflow 2: Manual Interactive
```
1. Go to: Actions > Manual Deploy
2. Click: Run workflow
3. Select: dev or qa
4. ✅ Deployment runs on your machine
```

### Workflow 3: Manual QA (dedicated workflow)
```
1. Go to: Actions > Deploy QA
2. Click: Run workflow
3. ✅ QA deployment runs on your machine
```

## 🎨 GitHub Actions UI

When you open **Actions** in your GitHub repository, you'll see:

```
Workflows:
├── CI-CD ........................... (Automatic on push/PR)
├── Deploy Dev ...................... (Automatic on PR to main)
├── Deploy QA ....................... (Manual trigger)
├── Manual Deploy ⭐ ................ (New - Interactive)
├── Maintenance ..................... (Existing)
└── Release ......................... (Existing)
```

## 🔐 Security Notes

- ✅ Runner must be in a secure location
- ✅ Docker should not expose ports to the internet
- ✅ Use proper firewall rules
- ✅ Keep GitHub Actions secrets safe
- ✅ Monitor runner logs for suspicious activity

## 🐛 Troubleshooting

### Runner not showing in GitHub Actions?
```bash
# Check if runner is running
bash scripts/runner-manager.sh status

# Start if not running
bash scripts/runner-manager.sh start

# Check logs for errors
bash scripts/runner-manager.sh logs
```

### Deployment fails?
```bash
# Run manually to debug
bash scripts/deploy-dev.sh

# Check Docker status
docker ps

# View container logs
docker logs demo-pipeline
```

### Docker issues?
```bash
# Verify Docker is running
docker --version

# Check permissions
groups $USER | grep docker

# Restart Docker if needed
```

## 📞 Support Resources

- 📖 **GitHub Actions Docs**: https://docs.github.com/en/actions
- 🐳 **Docker Docs**: https://docs.docker.com
- 🚀 **Deployment Guides**: See documentation files above
- 📋 **Runner Logs**: `~/actions-runner/_diag/Runner_*.log`

## 🎯 Next Steps

1. ✅ Verify setup: `bash scripts/check-runner.sh`
2. ✅ Test deployment: Use GitHub Actions UI
3. ✅ Monitor containers: `docker ps`
4. ✅ Check logs: `docker logs demo-pipeline`
5. ✅ Read full guides: `DEPLOYMENT_GUIDE.md`

## 📊 Configuration Reference

See `.github/deployment-config.json` for:
- Workflow configurations
- Deployment scripts
- Docker settings
- Troubleshooting guide
- API endpoints

## 🎉 You're All Set!

Your GitHub Actions pipeline is now ready to deploy locally to your machine. You can:

✅ Deploy to DEV automatically when merging to main  
✅ Deploy to QA manually from GitHub UI  
✅ Use interactive environment selector  
✅ Monitor deployments in real-time  
✅ View logs directly from GitHub  

**Start a deployment now!**

---

**Last Updated**: February 6, 2026  
**Version**: 1.0  
**Status**: ✅ PRODUCTION READY
