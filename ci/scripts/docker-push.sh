#!/usr/bin/env bash
set -euo pipefail

IMAGE_TAG=${1:-"latest"}
REGISTRY_USER=${DOCKERHUB_USER}
FULL_IMAGE="${REGISTRY_USER}/spring-petclinic:${IMAGE_TAG}"

echo "===> Tagging and Pushing image to registry: ${FULL_IMAGE}..."
docker tag "spring-petclinic:${IMAGE_TAG}" "${FULL_IMAGE}"
docker push "${FULL_IMAGE}"
