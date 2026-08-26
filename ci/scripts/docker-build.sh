#!/usr/bin/env bash
set -euo pipefail

# Find script directory and project root directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"

IMAGE_TAG=${1:-"spring-petclinic:latest"}

echo "===> Building Docker image: ${IMAGE_TAG}..."

# Pass explicit path to Dockerfile and root build context
docker build -f "${ROOT_DIR}/app/spring-petclinic/Dockerfile" -t "${IMAGE_TAG}" "${ROOT_DIR}/app/spring-petclinic"