#!/bin/bash
set -e

echo "🚀 Starting DEV deployment..."
echo ""

if [ ! -f "target/demo-pipeline-0.0.1-SNAPSHOT.jar" ]; then
  echo "📦 JAR file not found, building Maven package..."
  mvn clean package -DskipTests -q -Dmaven.wagon.http.retryHandler.class=standard -Dmaven.wagon.http.retryHandler.count=5
  echo ""
else
  echo "📦 Using existing JAR file..."
  echo ""
fi

# Step 1: Stop and remove old DEV container only (do NOT remove qa)
echo "⏹️  Stopping and removing old DEV container and image..."
docker rm -f demo-pipeline-dev 2>/dev/null || true
docker rmi -f demo-pipeline:dev 2>/dev/null || true
echo ""

# Step 2: Build new Docker image for DEV
echo "🏗️  Building Docker image for DEV (no cache)..."
docker build --no-cache -t demo-pipeline:dev .
echo ""

# Step 3: Start DEV environment (without --remove-orphans to preserve qa container)
echo "▶️  Starting DEV environment..."
docker compose -f docker-compose-dev.yml up -d
echo ""

# Step 4: Wait for application to be UP
echo "⏳ Waiting for DEV application to start (this may take a few seconds)..."

# Wait for container to be fully initialized
sleep 3

# Check if container is running
if ! docker ps --filter "name=demo-pipeline-dev" --filter "status=running" | grep -q "demo-pipeline-dev"; then
  echo "❌ DEV container failed to start"
  echo "📋 Container logs:"
  docker compose -f docker-compose-dev.yml logs
  exit 1
fi

# Wait for application to be ready using container health check
MAX_RETRIES=40
SLEEP_SECONDS=1

for i in $(seq 1 $MAX_RETRIES); do
  # Check container health status
  HEALTH_STATUS=$(docker inspect --format='{{.State.Health.Status}}' demo-pipeline-dev 2>/dev/null || echo "none")

  if [ "$HEALTH_STATUS" = "healthy" ]; then
    echo "✅ DEV application is UP and healthy!"
    break
  elif [ "$HEALTH_STATUS" = "unhealthy" ]; then
    echo "❌ DEV application is unhealthy"
    echo "📋 Container logs:"
    docker compose -f docker-compose-dev.yml logs
    exit 1
  fi

  if [ $((i % 10)) -eq 0 ]; then
    echo "Attempt $i/$MAX_RETRIES: waiting... (Status: $HEALTH_STATUS)"
  fi
  sleep $SLEEP_SECONDS

  if [ "$i" -eq "$MAX_RETRIES" ]; then
    echo "❌ DEV application did not become healthy after $MAX_RETRIES attempts"
    echo "📋 Container logs:"
    docker compose -f docker-compose-dev.yml logs
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