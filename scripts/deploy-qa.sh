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

# Step 1: Stop and remove old QA container only (do NOT remove dev)
echo "⏹️  Stopping and removing old QA container and image..."
docker rm -f demo-pipeline-qa 2>/dev/null || true
docker rmi -f demo-pipeline:qa 2>/dev/null || true
echo ""

# Step 2: Build new Docker image for QA (no cache)
echo "🏗️  Building Docker image for QA (no cache)..."
docker build --no-cache -t demo-pipeline:qa .
echo ""

# Step 3: Start QA environment
echo "▶️  Starting QA environment..."
docker compose -f docker-compose-qa.yml up -d --remove-orphans
echo ""

# Step 4: Wait for application to be UP
echo "⏳ Waiting for QA application to start (this may take a few seconds)..."

# Wait a bit for the container to fully initialize
sleep 2

MAX_RETRIES=30
SLEEP_SECONDS=2
URL="http://localhost:8082/actuator/health"

for i in $(seq 1 $MAX_RETRIES); do
  if curl -s $URL 2>/dev/null | grep -q "UP"; then
    echo "✅ QA application is UP!"
    break
  else
    if [ $((i % 5)) -eq 0 ]; then
      echo "Attempt $i/$MAX_RETRIES: waiting..."
    fi
    sleep $SLEEP_SECONDS
  fi

  if [ "$i" -eq "$MAX_RETRIES" ]; then
    echo "❌ QA application did not respond after $MAX_RETRIES attempts"
    echo "📋 Container logs:"
    docker compose -f docker-compose-qa.yml logs
    exit 1
  fi
done

# Step 5: Display status
echo ""
echo "📊 Container Status:"
docker compose -f docker-compose-qa.yml ps

echo ""
echo "🌐 Access the application at: http://localhost:8082"
echo "📝 Logs: docker compose -f docker-compose-qa.yml logs -f"