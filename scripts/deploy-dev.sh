#!/bin/bash
set -e

echo "🚀 Starting DEV deployment..."
echo ""

# Check if JAR file already exists (from previous build)
if [ ! -f "target/demo-pipeline-0.0.1-SNAPSHOT.jar" ]; then
  echo "📦 JAR file not found, building Maven package..."
  mvn clean package -DskipTests -q -Dmaven.wagon.http.retryHandler.class=standard -Dmaven.wagon.http.retryHandler.count=5
  echo ""
else
  echo "📦 Using existing JAR file..."
  echo ""
fi

# Step 1: Stop and remove old container
echo "⏹️  Stopping and removing old container..."
docker compose -f docker-compose-dev.yml down || true

echo ""

# Step 2: Remove old image to force rebuild
echo "🗑️  Removing old Docker image..."
docker rmi demo-pipeline:latest || true

echo ""

# Step 3: Build new Docker image with --no-cache
echo "🏗️  Building Docker image (no cache)..."
docker build --no-cache -t demo-pipeline:latest .

echo ""

# Step 4: Start DEV environment with new image
echo "▶️  Starting DEV environment..."
docker compose -f docker-compose-dev.yml up -d

echo ""

# Step 5: Display status
echo "✅ DEV deployment completed successfully!"
echo ""
echo "📊 Container Status:"
docker compose -f docker-compose-dev.yml ps

echo ""
echo "🌐 Access the application at: http://localhost:8081"
echo "📝 Logs: docker compose -f docker-compose-dev.yml logs -f"
