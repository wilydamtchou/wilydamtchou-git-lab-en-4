#!/bin/bash
echo "Building Docker image for DEV..."
docker build -t demo-pipeline:latest .

echo "Starting DEV environment..."
docker compose -f docker-compose-dev.yml up -d

echo "DEV deployment completed."
