# Update Deployment on EKS Cluster - Lab 5

This lab updates the containerized application by adding additional airports then containerizes a new version for upload to ECR.

## Preparation

1. Verify you're in the correct working directory of Lab 5:

    ```text
    PROJECT_ROOT/5-update-application-deployment/
    ```

## Update Containerize Web Application

1. Navigate to the **airports-data** directory:

    ```bash
    cd airport-data/
    ```

2. Update the following file in the web application **src/main/java/com/airport/locator/controller/LocatorController.java** by adding two additional airport data (make sure to inlcude semicolons):

    ```java
    airports.add(new Airport(4, "Dallas/Fort Worth International Airport", "KDFW", "Dallas-Fort, TX", "606"));
    airports.add(new Airport(5, "Denver International Airport", "KDEN", "Denver, CO", "5433"));
    ```

3. Build container image by running the following command in the root of the airport-data folder - **PROJECT_ROOT/5-update-application-deployment/airport-data**:

    ```bash
    docker build -t airport-locator:2.0.0 .
    ```

4. Re-tag container for upload to ECR:

    ```bash
    docker tag airport-locator:2.0.0 "${ECR_REPOSITORY_URI}:2.0.0"
    ```

5. (OPTIONAL) Authenticate to ECR if not logged in within 12 hours:

    ```bash
    aws ecr get-login-password --region "${AWS_REGION}" | docker login --username AWS --password-stdin "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
    ```

6. Push airport-data web application to ECR:

    ```bash
    docker push "${ECR_REPOSITORY_URI}:2.0.0"
    ```

## Deployment

1. Navigate back to the **PROJECT_ROOT/5-update-application-deployment/** from **PROJECT_ROOT/5-update-application-deployment/airport-data** directory:

    ```bash
    cd ../
    ```

2. Get updated Elastic Container Repository image to add to Kubernetes deployment in Step 3. Save output for next step:

    ```bash
    echo "${ECR_REPOSITORY_URI}:2.0.0"
    ```

3. Add the Elastic Container Repository image from Step 2 to the image field location (REPLACE_ME) in [airports-deployment.yaml](./1-airports-deployment.yaml) in text editor:

    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: airports-data
    spec:
      replicas: 3
      selector:
        matchLabels:
          app: airports-data
      template:
        metadata:
          labels:
            app: airports-data
        spec:
          containers:
            - name: airports-data
              image: ******REPLACE_ME*******
              imagePullPolicy: Always
              ports:
                - containerPort: 8080
                  protocol: TCP
              resources:
                requests:
                  memory: "512Mi"
                  cpu: "250m"
                limits:
                  memory: "1Gi"
                  cpu: "1000m"
    ```

4. Deploy [airports-deployment.yaml](./1-airports-deployment.yaml) deployment to EKS Cluster:

    ```bash
    kubectl apply -f 1-airports-deployment.yaml
    ```

5. Validate deployment is healthy by viewing a total of 3 airport-data-* in Running status with recent AGE:

    ```bash
    kubectl get pods
    ```

6. Get newly created application load balancer URL then paste into new browser tab to view the web application:

   ```bash
   aws elbv2 describe-load-balancers | jq -r ".LoadBalancers[].DNSName" | grep -i airports
   ```
