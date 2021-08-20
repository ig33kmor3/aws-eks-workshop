# Containerize Tomcat Web Application - Lab 3

This lab securely containerizes a Java Spring Boot MVC application with Tomcat Servlet for deployment into the cluster. Then, pushes containerized application to AWS Elastic Container Registry (ECR).

## Preparation

1. Verify you're in the correct working directory of Lab 3:

    ```text
    cd aws-eks-workshop/3-containerize-web-application/
    ```

2. Execute the following commands in your workspace. Skip to Step 3 if you want to automate instead:

    Create Registry

    ```bash
    aws ecr create-repository \
        --repository-name airports \
        --image-tag-mutability IMMUTABLE \
        --image-scanning-configuration scanOnPush=true
    ```

    Set ECR Lifecyle Policy

    ```bash
    aws ecr put-lifecycle-policy \
        --repository-name airports \
        --lifecycle-policy-text "file://policy.json"
    ```

    Set ECR Repository Variable

    ```bash
    ECR_REPOSITORY_URI=$(aws ecr describe-repositories | jq -r .repositories[].repositoryUri | grep airports)
    ```

    ```bash
    echo "export ECR_REPOSITORY_URI=${ECR_REPOSITORY_URI}" >> ~/.bash_profile && echo "${ECR_REPOSITORY_URI}"
    ```

3. (Optional) Execute The [containerize.sh](./containerize.sh) script in your workspace:

    ```bash
    chmod +x ./containerize.sh
    ```

    ```bash
    ./containerize.sh
    ```

## Containerize Web Application

1. Navigate to the **airports-data** directory:

    ```bash
    cd airport-data/
    ```

2. Build container image by running the following command in the root of this project folder:

    ```bash
    docker build -t airport-locator:1.0.0 .
    ```

3. Re-tag container for upload to ECR:

    ```bash
    . ~/.bash_profile
    ```

    ```bash
    docker tag airport-locator:1.0.0 "${ECR_REPOSITORY_URI}:1.0.0"
    ```

4. Authenticate to ECR:

    ```bash
    aws ecr get-login-password --region "${AWS_REGION}" | docker login --username AWS --password-stdin "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
    ```

5. Push airport-data web application to ECR:

    ```bash
    docker push "${ECR_REPOSITORY_URI}:1.0.0"
    ```
