# Launching an EKS Cluster - Lab 1

Prepare environment for deploying an EKS Cluster leveraging [eksctl](https://eksctl.io/).

## Deployment

Execute the [launch-setup.sh](./launch-setup.sh) script in your workspace:

```bash
chmod +x ./launch-setup.sh
```

```bash
./launch-setup.sh
```

```bash
eksctl create cluster -f airports.yaml
```

```bash
kubectl get nodes
```

The [launch-setup.sh](./launch-setup.sh) script accomplishes the following:

```bash
echo "Install Eksctl for Creating Clusters ..." && sleep 1
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv -v /tmp/eksctl /usr/local/bin
eksctl version
printf "\n"

echo "Install Kubectl for Managing Workloads ..." && sleep 1
sudo curl --silent --location -o /usr/local/bin/kubectl \
https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl
sudo chmod +x /usr/local/bin/kubectl
kubectl version
printf "\n"

echo "Install Helm 3 for Kubernetes Package Management ..." && sleep 1
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
printf "\n"

echo "Install Additional Helper Tools ..." && sleep 1
kubectl completion bash >>  ~/.bash_completion
. ~/.bash_completion
eksctl completion bash >> ~/.bash_completion
. ~/.bash_completion
for command in kubectl jq envsubst aws eksctl kubectl helm
do
    which $command &>/dev/null && echo "$command in path" || echo "$command NOT FOUND"
done
printf "\n"

echo "Create EKS Cluster Configuration File - airports.yaml ..." && sleep 1
cat << EOF > airports.yaml
---
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

# cluster configuration metadata
metadata:
  name: airports
  region: ${AWS_REGION}
  version: "1.19"

# availability zones for deployment
availabilityZones: ["${AWS_REGION}a", "${AWS_REGION}b", "${AWS_REGION}c"]

# add general and intensive managed node groups
managedNodeGroups:
- name: nodegroup
  desiredCapacity: 3
  ssh:
    allow: true
    publicKeyName: eks-workshop

# configure irsa for kubernetes cluster - service accounts  
iam:
  withOIDC: true
  serviceAccounts:
  - metadata:
      name: aws-load-balancer-controller
      namespace: kube-system
    wellKnownPolicies:
      awsLoadBalancerController: true
  - metadata:
      name: ebs-csi-controller-sa
      namespace: kube-system
    wellKnownPolicies:
      ebsCSIController: true
  - metadata:
      name: efs-csi-controller-sa
      namespace: kube-system
    wellKnownPolicies:
      efsCSIController: true
  - metadata:
      name: external-dns
      namespace: kube-system
    wellKnownPolicies:
      externalDNS: true
  - metadata:
      name: cert-manager
      namespace: cert-manager
    wellKnownPolicies:
      certManager: true
  - metadata:
      name: cluster-autoscaler
      namespace: kube-system
      labels: {aws-usage: "cluster-ops"}
    wellKnownPolicies:
      autoScaler: true
  - metadata:
      name: build-service
    wellKnownPolicies:
      imageBuilder: true
EOF
```
