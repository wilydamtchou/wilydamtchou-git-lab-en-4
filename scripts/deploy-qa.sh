#!/bin/bash
set -e

echo "🚀 Starting QA deployment..."
echo ""

# Check if JAR file exists (from workflow build)
if [ ! -f "target/demo-pipeline-0.0.1-SNAPSHOT.jar" ]; then
  echo "📦 JAR file not found, building Maven package..."
  mvn clean package -DskipTests -q -Dmaven.wagon.http.retryHandler.class=standard -Dmaven.wagon.http.retryHandler.count=5
  echo ""
fi

# Step 1: Stop and remove old container
echo "⏹️  Stopping and removing old container..."
docker compose -f docker-compose-qa.yml down || true

echo ""

# Step 2: Remove old image to force rebuild
echo "🗑️  Removing old Docker image..."
docker rmi demo-pipeline:latest || true

echo ""

# Step 3: Build new Docker image with --no-cache
echo "🏗️  Building Docker image (no cache)..."
docker build --no-cache -t demo-pipeline:latest .

echo ""

# Step 4: Start QA environment with new image
echo "▶️  Starting QA environment..."
docker compose -f docker-compose-qa.yml up -d

echo ""

# Step 5: Display status
echo "✅ QA deployment completed successfully!"
echo ""
echo "📊 Container Status:"
docker compose -f docker-compose-qa.yml ps

echo ""
echo "🌐 Access the application at: http://localhost:8082"
echo "📝 Logs: docker compose -f docker-compose-qa.yml logs -f"
