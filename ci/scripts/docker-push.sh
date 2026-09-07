#!/usr/bin/env bash
set -euo pipefail

IMAGE_TAG=${1:-"latest"}
APP_NAME=${2:-"spring-petclinic"}

# AWS ECR Configuration
AWS_ACCOUNT_ID=${AWS_ACCOUNT_ID:-"173331852212"}
AWS_REGION=${AWS_REGION:-"us-east-1"}
ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

FULL_IMAGE="${ECR_REGISTRY}/${APP_NAME}:${IMAGE_TAG}"

echo "===> Tagging local image ${APP_NAME}:${IMAGE_TAG} to ${FULL_IMAGE}..."
docker tag "${APP_NAME}:${IMAGE_TAG}" "${FULL_IMAGE}"

echo "===> Pushing image to AWS ECR: ${FULL_IMAGE}..."
docker push "${FULL_IMAGE}"

echo "===> Successfully pushed ${FULL_IMAGE} to AWS ECR!"