FROM eclipse-temurin:25-jdk-jammy

VOLUME /tmp

COPY target/*.jar app.jar

ENTRYPOINT ["java", "-jar", "/app.jar"]