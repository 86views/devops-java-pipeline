#!/usr/bin/env bash
set -euo pipefail

IMAGE_TAG=${1:?"Usage: trivy-scan.sh <image:tag>"}

echo "===> Scanning ${IMAGE_TAG} for HIGH/CRITICAL vulnerabilities..."

docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v trivy-cache:/root/.cache/ \
  aquasec/trivy:latest image \
  --exit-code 1 \
  --severity HIGH,CRITICAL \
  --ignore-unfixed \
  "${IMAGE_TAG}"
