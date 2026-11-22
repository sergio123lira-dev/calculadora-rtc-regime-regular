FROM eclipse-temurin:21-jdk AS build
WORKDIR /app
COPY . .
RUN chmod +x mvnw \
 && mkdir -p calculadora/db \
 && ./mvnw -B -q flyway:migrate -Dflyway.configFiles=./flyway/flyway-pro.conf \
 && ./mvnw -B -q -DskipTests package

FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
COPY --from=build /app/calculadora ./calculadora
ENV SPRING_PROFILES_ACTIVE=offline
CMD ["sh", "-c", "java -jar app.jar --server.port=${PORT:-8080}"]
