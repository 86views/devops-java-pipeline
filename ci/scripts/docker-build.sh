#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME=${1:-"spring-petclinic:local"}

echo "===> Building Docker image: ${IMAGE_NAME}..."
docker build -t "${IMAGE_NAME}" app/spring-petclinic/