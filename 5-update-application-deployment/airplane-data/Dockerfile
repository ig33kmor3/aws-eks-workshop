# create builder container to use maven
FROM public.ecr.aws/h5r1n5l4/maven:3.8.1-jdk-11-slim AS builder
WORKDIR /app
COPY . ./
RUN mvn clean package

# create container to run java tomcat mvc
FROM public.ecr.aws/h5r1n5l4/amazoncorretto:11.0.12-alpine
WORKDIR /app
COPY --from=builder /app/target/locator-release.jar .
EXPOSE 8080
ENTRYPOINT ["java", "-Duser.timezone=GMT", "-jar", "locator-release.jar"]