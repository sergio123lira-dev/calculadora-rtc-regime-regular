FROM maven:3.9-eclipse-temurin-25 AS build
WORKDIR /app
COPY . .
RUN mkdir -p calculadora/db \
 && mvn -B -q flyway:migrate -Dflyway.configFiles=./flyway/flyway-pro.conf \
 && mvn -B -q -DskipTests package

FROM eclipse-temurin:25-jre
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
COPY --from=build /app/calculadora ./calculadora
ENV SPRING_PROFILES_ACTIVE=offline
CMD ["sh", "-c", "java -jar app.jar --server.port=${PORT:-8080}"]
