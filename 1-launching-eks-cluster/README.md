# Launching an EKS Cluster - Lab 1

This lab prepares environment for deploying an EKS Cluster leveraging [eksctl](https://eksctl.io/).

## Preparation

1. Verify you're in the correct working directory of Lab 1:

    ```text
    cd aws-eks-workshop/1-launching-eks-cluster/
    ```

2. Execute the following commands in the above working directory. Skip to Step 3 if you want to automate instead:

    Install eksctl to aid in creating an EKS cluster

    ```bash
    curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
    ```

    ```bash
    sudo mv -v /tmp/eksctl /usr/local/bin && eksctl version
    ```

    Install Kubectl for managing workloads deployed in cluster

    ```bash
    sudo curl --silent --location -o /usr/local/bin/kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl
    ```

    ```bash
    sudo chmod +x /usr/local/bin/kubectl && kubectl version
    ```

    Install Helm 3 for kubernetes package management

    ```bash
    curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
    ```

    Install additional helper tools

    ```bash
    kubectl completion bash >>  ~/.bash_completion && . ~/.bash_completion
    ```

    ```bash
    eksctl completion bash >> ~/.bash_completion && . ~/.bash_completion
    ```

    ```bash  
    for command in kubectl jq envsubst aws eksctl kubectl helm
    do
        which $command &>/dev/null && echo "$command in path" || echo "$command NOT FOUND"
    done
    ```

    Create EKS cluster configuration file

    ```bash
    . ~/.bash_profile
    ```

    ```bash
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

    Create the cluster. This can take up to 20 minutes

    ```bash
    eksctl create cluster -f airports.yaml
    ```

    Make sure all nodes are operational.

    ```bash
    kubectl get nodes
    ```

3. (Optional) Execute the [launch-setup.sh](./launch-setup.sh) script in your workspace only if you don't want to manually type the commands above:

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
