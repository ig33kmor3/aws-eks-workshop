# Preparing EKS Cluser for Applications - Lab 2

* Verify AWS Load Balancer IAM roles for service account is configured
* Deploy AWS Load Balancer Controller for external connectivity
* Deploy official Kubernetes dashboard

## Deployment

Execute the [prepare-cluster.sh](./prepare-cluster.sh) script in your workspace:

```bash
chmod +x ./prepare-cluster.sh
```

```bash
./prepare-cluster.sh
```

```bash
kubectl logs -n kube-system deployments/aws-load-balancer-controller
```

```bash
kubectl -n kube-system get deployments
```

The [prepare-cluster.sh](./prepare-cluster.sh) script accomplishes the following:

```bash
CLUSTER_NAME="airports"

echo "Install AWS Load Balancer Controller ..." && sleep 1
kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller/crds?ref=master"
helm repo add eks https://aws.github.io/eks-charts
helm upgrade -i aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=${CLUSTER_NAME} \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
printf "\n"

echo "Deploy Kubernetes Dashboard ..." && sleep 1
export DASHBOARD_VERSION="v2.0.0"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/${DASHBOARD_VERSION}/aio/deploy/recommended.yaml
```
