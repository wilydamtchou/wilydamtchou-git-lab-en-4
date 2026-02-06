#!/bin/bash
set -e

echo "🚀 Starting QA deployment..."
echo ""

# ==================== DIAGNOSTIC ====================
echo "📊 System Resources Diagnostic:"
echo "Disk space:"
df -h | grep -E "Filesystem|/$" || true
echo ""
echo "Memory available:"
vm_stat 2>/dev/null | grep "Pages free" || free -h || true
echo ""
echo "Docker info:"
docker system df || true
echo ""
echo "Running containers:"
docker ps --all || true
echo ""
echo "===================================================="
echo ""

if [ ! -f "target/demo-pipeline-0.0.1-SNAPSHOT.jar" ]; then
  echo "📦 JAR file not found, building Maven package..."
  mvn clean package -DskipTests -q -Dmaven.wagon.http.retryHandler.class=standard -Dmaven.wagon.http.retryHandler.count=5
  echo ""
else
  echo "📦 Using existing JAR file..."
  echo ""
fi

# Step 1: Stop and remove old QA container only (do NOT remove dev)
echo "⏹️  Stopping and removing old QA container and image..."
docker rm -f demo-pipeline-qa 2>/dev/null || true
docker rmi -f demo-pipeline:qa 2>/dev/null || true
echo ""

# Step 2: Build new Docker image for QA
echo "🏗️  Building Docker image for QA (no cache)..."
docker build --no-cache -t demo-pipeline:qa . || {
  echo "❌ Docker build failed!"
  echo "📋 Docker images:"
  docker images || true
  echo ""
  echo "📋 Docker system prune (to free space):"
  docker system prune -f || true
  exit 1
}
echo ""

# Verify image was created
if ! docker images | grep -q "demo-pipeline.*qa"; then
  echo "❌ QA image not found after build!"
  docker images || true
  exit 1
fi
echo "✅ QA image created successfully"
echo ""

# Step 3: Start QA environment (without --remove-orphans to preserve dev container)
echo "▶️  Starting QA environment..."
docker compose -f docker-compose-qa.yml up -d
echo ""

# Step 4: Wait for application to be UP
echo "⏳ Waiting for QA application to start (this may take a few seconds)..."

# Wait for container to be fully initialized
sleep 3

# Check if container is running
if ! docker ps --filter "name=demo-pipeline-qa" --filter "status=running" | grep -q "demo-pipeline-qa"; then
  echo "❌ QA container failed to start"
  echo ""
  echo "📋 Container status:"
  docker ps -a | grep demo-pipeline-qa || true
  echo ""
  echo "📋 Container logs:"
  docker compose -f docker-compose-qa.yml logs demo-pipeline-qa 2>&1 | tail -100 || true
  echo ""
  echo "📋 Docker system state:"
  docker system df || true
  exit 1
fi

echo "✅ Container is running"
echo ""

# Wait for application to be ready using container health check
MAX_RETRIES=40
SLEEP_SECONDS=1

for i in $(seq 1 $MAX_RETRIES); do
  # Check container health status
  HEALTH_STATUS=$(docker inspect --format='{{.State.Health.Status}}' demo-pipeline-qa 2>/dev/null || echo "none")

  if [ "$HEALTH_STATUS" = "healthy" ]; then
    echo "✅ QA application is UP and healthy!"
    break
  elif [ "$HEALTH_STATUS" = "unhealthy" ]; then
    echo "❌ QA application is unhealthy"
    echo "📋 Container logs:"
    docker compose -f docker-compose-qa.yml logs
    exit 1
  fi

  if [ $((i % 10)) -eq 0 ]; then
    echo "Attempt $i/$MAX_RETRIES: waiting... (Status: $HEALTH_STATUS)"
  fi
  sleep $SLEEP_SECONDS

  if [ "$i" -eq "$MAX_RETRIES" ]; then
    echo "❌ QA application did not become healthy after $MAX_RETRIES attempts"
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
