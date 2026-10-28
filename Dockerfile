# syntax=docker/dockerfile:1

FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /app

# Copy pom first to cache dependencies
COPY pom.xml .
RUN mvn -DskipTests dependency:go-offline

# Copy source and build
COPY src ./src
RUN mvn -DskipTests package

# Runtime image (smaller)
FROM eclipse-temurin:17-jre
WORKDIR /app

# Copy the built jar from the build stage
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]