# Airport Data Locator

This is a sample repository to practice building docker containers. Additionally, it can be used to test deployments 
into Kubernetes clusters. It leverages a Java Spring Boot MVC application with Tomcat Servlet.

![frontend](./app.png)

## Run Locally

Build container image by running the following command in the root of this project folder: 

```bash
docker build -t airport-locator:1.0.0 .
```

Run container locally for testing:

```bash
docker run --name airport-locator -p 8080:8080 -d airport-locator:1.0.0
```

Navigate to URL in your web browser:

```
http://localhost:8080
```

Stop and cleanup docker container:

```bash
docker stop airport-locator && docker rm airport-locator && docker image rm airport-locator:1.0.0
```