#!/bin/bash

# Cleanup Docker environment on self-hosted runner
# This helps prevent resource exhaustion issues

echo "🧹 Cleaning up Docker environment..."
echo ""

echo "📊 Docker system before cleanup:"
docker system df
echo ""

# Remove dangling images (safe to remove)
echo "🗑️  Removing dangling images..."
docker image prune -f || true
echo ""

# Remove dangling volumes (safe to remove)
echo "🗑️  Removing dangling volumes..."
docker volume prune -f || true
echo ""

# Remove stopped containers (safe to remove)
echo "🗑️  Removing stopped containers..."
docker container prune -f || true
echo ""

# Optional: Remove old build cache
echo "🗑️  Removing build cache (optional)..."
docker builder prune -f --filter "unused-for=24h" || true
echo ""

echo "📊 Docker system after cleanup:"
docker system df
echo ""

echo "✅ Cleanup completed"
