#!/bin/bash
set -e

echo "🚀 Starting DEV deployment..."
echo ""

# Step 1: Stop and remove old container
echo "⏹️  Stopping and removing old container..."
docker compose -f docker-compose-dev.yml down || true

echo ""

# Step 2: Rebuild the JAR file
echo "📦 Building Maven package..."
mvn clean package -DskipTests -q

echo ""

# Step 3: Remove old image to force rebuild
echo "🗑️  Removing old Docker image..."
docker rmi demo-pipeline:latest || true

echo ""

# Step 4: Build new Docker image with --no-cache
echo "🏗️  Building Docker image (no cache)..."
docker build --no-cache -t demo-pipeline:latest .

echo ""

# Step 5: Start DEV environment with new image
echo "▶️  Starting DEV environment..."
docker compose -f docker-compose-dev.yml up -d

echo ""

# Step 6: Display status
echo "✅ DEV deployment completed successfully!"
echo ""
echo "📊 Container Status:"
docker compose -f docker-compose-dev.yml ps

echo ""
echo "🌐 Access the application at: http://localhost:8081"
echo "📝 Logs: docker compose -f docker-compose-dev.yml logs -f"
