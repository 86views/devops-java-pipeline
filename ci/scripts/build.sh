#!/usr/bin/env bash
set -euo pipefail

echo "===> Compiling application and running unit tests..."
cd app/spring-petclinic
./mvnw clean test