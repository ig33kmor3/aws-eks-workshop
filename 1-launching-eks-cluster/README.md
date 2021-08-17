# Launching an EKS Cluster - Lab 1

This lab prepares environment for deploying an EKS Cluster leveraging [eksctl](https://eksctl.io/).

## Preparation

1. Verify you're in the correct working directory of Lab 1:

    ```text
    PROJECT_ROOT/1-launching-eks-cluster/
    ```

2. Execute the [launch-setup.sh](./launch-setup.sh) script in your workspace:

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
    # Install Eksctl for Creating Clusters
    curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
    sudo mv -v /tmp/eksctl /usr/local/bin
    eksctl version
    
    # Install Kubectl for Managing Workloads
    sudo curl --silent --location -o /usr/local/bin/kubectl \
    https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl
    sudo chmod +x /usr/local/bin/kubectl
    kubectl version
    
    # Install Helm 3 for Kubernetes Package Management
    curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
    
    # Install Additional Helper Tools
    kubectl completion bash >>  ~/.bash_completion
    . ~/.bash_completion
    eksctl completion bash >> ~/.bash_completion
    . ~/.bash_completion
    for command in kubectl jq envsubst aws eksctl kubectl helm
    do
        which $command &>/dev/null && echo "$command in path" || echo "$command NOT FOUND"
    done
    
    # Create EKS Cluster Configuration File - airports.yaml
    . ~/.bash_profile
    cat << EOF > airports.yaml
    ---
    apiVersion: eksctl.io/v1alpha5
    kind: ClusterConfig
    
    metadata:
      name: airports
      region: ${AWS_REGION}
      version: "1.19"
    
    availabilityZones: ["${AWS_REGION}a", "${AWS_REGION}b", "${AWS_REGION}c"]
    
    managedNodeGroups:
    - name: nodegroup
      desiredCapacity: 3
      ssh:
        allow: true
        publicKeyName: eks-workshop
    
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
