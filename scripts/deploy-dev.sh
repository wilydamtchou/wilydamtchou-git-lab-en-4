#!/bin/bash
set -e

echo "🚀 Starting DEV deployment..."
echo ""

# Check if JAR file exists (from previous build)
if [ ! -f "target/demo-pipeline-0.0.1-SNAPSHOT.jar" ]; then
  echo "📦 JAR file not found, building Maven package..."
  mvn clean package -DskipTests -q -Dmaven.wagon.http.retryHandler.class=standard -Dmaven.wagon.http.retryHandler.count=5
  echo ""
else
  echo "📦 Using existing JAR file..."
  echo ""
fi

# Step 1: Stop and remove old containers and images
echo "⏹️  Stopping and removing old containers and images..."
docker rm -f demo-pipeline-dev demo-pipeline-qa 2>/dev/null || true
docker rmi -f demo-pipeline:latest 2>/dev/null || true
echo ""

# Step 2: Build new Docker image
echo "🏗️  Building Docker image (no cache)..."
docker build --no-cache -t demo-pipeline:latest .
echo ""

# Step 3: Start DEV environment
echo "▶️  Starting DEV environment..."
docker compose -f docker-compose-dev.yml up -d --remove-orphans
echo ""

# Step 4: Wait for application to be UP
echo "⏳ Waiting for DEV application to start..."

MAX_RETRIES=20
SLEEP_SECONDS=3
URL="http://localhost:8081/actuator/health"

for i in $(seq 1 $MAX_RETRIES); do
  if curl -s $URL | grep -q "UP"; then
    echo "✅ DEV application is UP!"
    break
  else
    echo "Attempt $i/$MAX_RETRIES: waiting..."
    sleep $SLEEP_SECONDS
  fi

  if [ "$i" -eq "$MAX_RETRIES" ]; then
    echo "❌ DEV application did not respond after $MAX_RETRIES attempts"
    echo "📋 Container logs:"
    docker compose -f docker-compose-dev.yml logs -f
    exit 1
  fi
done

# Step 5: Display status
echo ""
echo "📊 Container Status:"
docker compose -f docker-compose-dev.yml ps

echo ""
echo "🌐 Access the application at: http://localhost:8081"
echo "📝 Logs: docker compose -f docker-compose-dev.yml logs -f"