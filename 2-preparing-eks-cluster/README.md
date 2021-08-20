# Preparing EKS Cluster for Applications - Lab 2

This lab executes the following:

* Verify AWS Load Balancer IAM roles for service account is configured
* Deploy AWS Load Balancer Controller for external connectivity
* Deploy official Kubernetes dashboard

## Preparation

1. Verify you're in the correct working directory of Lab 2:

    ```text
    cd aws-eks-workshop/2-preparing-eks-cluster/
    ```

2. Execute the following commands in your workspace. Skip to Step 3 if you want to automate instead:

    ```bash
    export CLUSTER_NAME="airports"
    ```

    Install AWS Load Balancer Controller

    ```bash
    kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller/crds?ref=master"
    ```

    ```bash
    helm repo add eks https://aws.github.io/eks-charts
    ```

    ```bash
    helm upgrade -i aws-load-balancer-controller eks/aws-load-balancer-controller \
      -n kube-system \
      --set clusterName=${CLUSTER_NAME} \
      --set serviceAccount.create=false \
      --set serviceAccount.name=aws-load-balancer-controller
    ```

    ```bash
    kubectl logs -n kube-system deployments/aws-load-balancer-controller
    ```

    Deploy Kubernetes Dashboard

    ```bash
    export DASHBOARD_VERSION="v2.0.5"
    ```

    ```bash
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/${DASHBOARD_VERSION}/aio/deploy/recommended.yaml
    ```

3. (Optional) Execute the [prepare-cluster.sh](./prepare-cluster.sh) script in your workspace:

    ```bash
    chmod +x ./prepare-cluster.sh
    ```

    ```bash
    ./prepare-cluster.sh
    ```

    ```bash
    kubectl logs -n kube-system deployments/aws-load-balancer-controller
    ```

## View Kubernetes Metrics Dashboard

1. Establish proxy request to dashboard:

    ```bash
    kubectl proxy --port=8080 --address=0.0.0.0 --disable-filter=true &
    ```

2. In your Cloud9 workspace, click **Tools / Preview / Preview Running Application**

3. Append the following to URL:

    ```text
    /api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
    ```

4. Pop Out screen larger for access:

    ![2-dashboard](./images/2-dashboard.png)

    ![1-dashboard](./images/1-dashboard.png)

5. In a new terminal in Cloud9 workspace, request a token for dashboard and input into Dashboard:

    ```bash
    aws eks get-token --cluster-name airports | jq -r '.status.token'
    ```

6. View Kubernetes Dashboard:

    ![3-dashboard](./images/3-dashboard.png)
