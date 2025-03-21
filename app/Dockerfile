# MULTISTAGE
# Step 1: Build
FROM gradle:8.2.1-jdk17 AS build

WORKDIR /app

COPY --chown=gradle:gradle . .

RUN gradle clean build -x test

# Step 2: Runtime
FROM amazoncorretto:17-alpine
RUN addgroup -S app && adduser -S app -G app
WORKDIR /apps

COPY --from=build /app/build/libs/app.jar app.jar
RUN chown -R app:app /apps
USER app
EXPOSE 8080

CMD ["java", "-jar", "app.jar"]