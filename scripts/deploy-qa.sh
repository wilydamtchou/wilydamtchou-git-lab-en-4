#!/bin/bash
echo "Building Docker image for QA..."
docker build -t demo-pipeline:latest .

echo "Starting QA environment..."
docker compose -f docker-compose-qa.yml up -d

echo "QA deployment completed."
