#!/usr/bin/env bash
set -euo pipefail

IMAGE_TAG=${1:-"spring-petclinic:latest"}

echo "===> Building Docker image: ${IMAGE_TAG}..."

# Execute docker build targeting app/spring-petclinic/Dockerfile
docker build -f app/spring-petclinic/Dockerfile -t "${IMAGE_TAG}" app/spring-petclinic