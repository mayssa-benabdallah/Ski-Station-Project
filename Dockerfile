FROM openjdk:11-jre-slim
WORKDIR /app
COPY target/SkiStationProject-1.0.jar .
EXPOSE 8089
CMD ["java", "-jar", "skistationproject-1.0.jar"]