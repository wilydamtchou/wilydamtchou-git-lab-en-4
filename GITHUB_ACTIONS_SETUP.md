# GitHub Actions Self-Hosted Runner Configuration

## Overview

This project uses a **self-hosted runner** to execute deployments locally on your machine.

## Runner Configuration

### 1. Verify that the Runner is Active

The runner must be running on your local machine. Check in:
- GitHub > Repository Settings > Actions > Runners

### 2. Local Machine Requirements

#### System Requirements:
- **OS**: macOS (your current configuration)
- **Shell**: zsh
- **Docker**: Installed and running
- **Docker Compose**: Installed (v1.29.0 or newer)
- **Permissions**: The runner must have access to Docker

#### Verify prerequisites:
```bash
# Check Docker
docker --version

# Check Docker Compose
docker-compose --version

# Verify that the runner is active
ps aux | grep actions-runner
```

## Available Workflows

### 1. **CI-CD Pipeline** (ci.yml)
- **Trigger**: Push to all branches, Pull Requests to main
- **Jobs**:
  - Build & Verify (ubuntu-latest)
  - Cucumber Tests (ubuntu-latest)
  - Newman Tests (ubuntu-latest)
  - **Deploy to DEV** (self-hosted) - Only on main

### 2. **Deploy Dev** (deploy-dev.yml)
- **Trigger**: Pull Request to main
- **Runner**: self-hosted
- **Action**: Executes `scripts/deploy-dev.sh`

### 3. **Deploy QA** (deploy-qa.yml)
- **Trigger**: Manual (workflow_dispatch)
- **Runner**: self-hosted
- **Action**: Executes `scripts/deploy-qa.sh`

### 4. **Manual Deploy** (manual-deploy.yml) ⭐ **NEW**
- **Trigger**: Manual (workflow_dispatch)
- **Runner**: self-hosted
- **Options**:
  - Choose environment: **dev** or **qa**
  - User-friendly interface with dropdown
- **Action**: Executes the corresponding script

## How to Use

### Automatic Deployment (CI-CD)
1. Create a Pull Request to `main`
2. Tests run on `ubuntu-latest`
3. If tests pass, DEV deployment runs on `self-hosted`

### Manual Deployment
1. Go to **Actions** > **Manual Deploy**
2. Click **Run workflow**
3. Select the environment (dev or qa)
4. Click **Run workflow**

The deployment will run on your local machine!

## Deployment Scripts

### deploy-dev.sh
```bash
#!/bin/bash
echo "Building Docker image for DEV..."
docker build -t demo-pipeline:latest .

echo "Starting DEV environment..."
docker compose -f docker-compose-dev.yml up -d

echo "DEV deployment completed."
```

### deploy-qa.sh
```bash
#!/bin/bash
echo "Building Docker image for QA..."
docker build -t demo-pipeline:latest .

echo "Starting QA environment..."
docker compose -f docker-compose-qa.yml up -d

echo "QA deployment completed."
```

## Troubleshooting

### ❌ Runner is not showing in GitHub

**Check runner status**:
```bash
# Navigate to runner folder
cd ~/actions-runner

# Check logs
tail -f _diag/Runner_*.log
```

### ❌ Deployments fail with Docker

**Check Docker**:
```bash
# Restart Docker
docker ps

# Check permissions
groups $USER | grep docker
```

### ❌ Permission denied on scripts

```bash
# Make scripts executable
chmod +x scripts/deploy-dev.sh
chmod +x scripts/deploy-qa.sh
```

## Deployment Architecture

```
GitHub Actions
    │
    ├─ Build & Tests (ubuntu-latest)
    │   ├─ Checkout code
    │   ├─ Setup Java
    │   ├─ Run Maven Build
    │   ├─ Run Cucumber Tests
    │   └─ Run Newman Tests
    │
    └─ Deploy (self-hosted) ⭐ On your machine
        ├─ Checkout code
        └─ Execute deployment script
            ├─ Build Docker image
            └─ Start containers with docker-compose
```

## Security

⚠️ **Important**: 
- Make sure your machine is secure
- GitHub secrets are not exposed in logs
- Docker credentials must be configured locally
- The runner must be on a secure network

## Next Steps

✅ Your workflows are now configured to use the local runner
✅ DEV/QA deployments run on your machine
✅ You can trigger deployments manually from GitHub

For more information: https://docs.github.com/en/actions/hosting-your-own-runners
