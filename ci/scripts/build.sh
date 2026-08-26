#!/usr/bin/env bash
set -euo pipefail

echo "===> Compiling application and running unit tests..."

# Run inside a subshell so pwd remains untouched for subsequent stages
(
  cd app/spring-petclinic
  chmod +x mvnw
  ./mvnw clean test -Dtest='!PostgresIntegrationTests'
)