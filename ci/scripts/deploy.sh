#!/usr/bin/env bash
set -euo pipefail

echo "===> Deploying local stack via Docker Compose..."
docker compose -f docker/docker-compose.stage1.yml up -d --build mysql adminer app nginx