
FROM maven:3.9-amazoncorretto-20 AS build
WORKDIR /build


COPY promobridge-sdk-2.0.jar /tmp/
COPY promobridge-sdk-2.0.pom /tmp/
RUN mvn install:install-file -X \
    -Dfile=/tmp/promobridge-sdk-2.0.jar \
    -DpomFile=/tmp/promobridge-sdk-2.0.pom \

COPY pom.xml .
RUN mvn dependency:go-offline


COPY src ./src
RUN mvn clean package -DskipTests


FROM amazoncorretto:21-alpine
WORKDIR /app


COPY --from=build /build/target/*.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]