# Containerize Tomcat Web Application - Lab 3

Securely containerize a Java Spring Boot MVC application with Tomcat Servlet for deployment into the cluster. Push containerized application to AWS Elastic Container Registry (ECR).

## Preparation

Execute the [containerize.sh](./containerize.sh) script in your workspace:

```bash
chmod +x ./containerize.sh
```

```bash
./containerize.sh
```

The [containerize.sh](./containerize.sh) script accomplishes the following:

```bash
echo "Create ECR Repository ..." && sleep 1
aws ecr create-repository \
    --repository-name airports \
    --image-tag-mutability IMMUTABLE \
    --image-scanning-configuration scanOnPush=true
printf "\n"

echo "Set ECR Lifecyle Policy" && sleep 1
aws ecr put-lifecycle-policy \
    --repository-name airports \
    --lifecycle-policy-text "file://policy.json"
printf "\n"

echo "Set ECR Repository Variable ..." && sleep 1
ECR_REPOSITORY_URI=$(aws ecr describe-repositories | jq -r .repositories[].repositoryUri | grep airports)
echo ${ECR_REPOSITORY_URI}
```

## Containerize Web Application

Navigate to the **airports-data** directory:

```bash
cd airport-data
```

Build container image by running the following command in the root of this project folder:

```bash
docker build -t airport-locator:1.0.0 .
```

Re-tag container for upload to ECR:

```bash
docker tag airport-locator:1.0.0 ${ECR_REPOSITORY_URI}:1.0.0
```

Authenicate to ECR:

```bash
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
```

Push airport-data web application to ECR:

```bash
docker push ${ECR_REPOSITORY_URI}:1.0.0
```
