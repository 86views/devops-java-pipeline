#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"
SONAR_HOST_URL=${SONAR_HOST_URL:-"http://sonarqube:9000"}

echo "===> Running SonarQube Static Code Analysis..."

if [[ -z "${SONAR_TOKEN:-}" ]]; then
  echo "SONAR_TOKEN is not set – skipping SonarQube analysis"
  exit 0   # or exit 1 if analysis is mandatory
fi

(
  cd "${ROOT_DIR}/app/spring-petclinic"
  chmod +x mvnw
  ./mvnw sonar:sonar \
    -Dsonar.host.url="${SONAR_HOST_URL}" \
    -Dsonar.token="${SONAR_TOKEN}" \
    -Dsonar.projectKey="spring-petclinic"
)