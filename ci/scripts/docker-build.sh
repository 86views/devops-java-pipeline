#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"

IMAGE_TAG=${1:-"spring-petclinic:latest"}

echo "===> Building Docker image: ${IMAGE_TAG}..."

docker build \
  --build-arg CACHEBUST=$(date +%s) \
  -f "${ROOT_DIR}/app/spring-petclinic/Dockerfile" \
  -t "${IMAGE_TAG}" \
  "${ROOT_DIR}/app/spring-petclinic"