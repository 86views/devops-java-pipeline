#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"

echo "===> Compiling application and running unit tests..."

# Run inside a subshell using absolute paths relative to root
(
  cd "${ROOT_DIR}/app/spring-petclinic"
  chmod +x mvnw
  ./mvnw clean test -Dtest='!MySqlIntegrationTests,!PostgresIntegrationTests' -DfailIfNoTests=false
)