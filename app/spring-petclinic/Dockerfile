# Stage 1: Build the Application
FROM eclipse-temurin:17-jdk-alpine AS builder
RUN apk update && apk upgrade --no-cache

WORKDIR /app

# Copy Maven wrapper and POM first to leverage Docker layer caching
COPY .mvn/ .mvn
COPY mvnw pom.xml ./

# Download dependencies offline to speed up subsequent builds
RUN ./mvnw dependency:go-offline -B

# Copy source code and build the executable JAR
COPY src ./src
RUN ./mvnw clean package -DskipTests

# Stage 2: Runtime Image
FROM eclipse-temurin:17-jre-alpine
RUN apk update && apk upgrade --no-cache

WORKDIR /app

RUN apk add --no-cache curl

# Create non-root user for security best practices
RUN addgroup -S petclinic && adduser -S petclinic -G petclinic
USER petclinic:petclinic

# Copy compiled JAR from builder stage
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]