# Project Setup - Lab 0

This lab prepares your workspace to interact with AWS EKS by installing the required utilities. This configuration assumes you're using AWS Cloud9 and the lab has already been cloned to your Cloud9 Workspace per [here](../README.md).

## Preparation

1. Verify you're in the correct working directory of Lab 0:

    ```text
    PROJECT_ROOT/0-setup/
    ```

2. Execute the [setup.sh](./setup.sh) script on your workspace:

    ```bash
    chmod +x ./setup.sh
    ```

    ```bash
    ./setup.sh
    ```

    The [setup.sh](./setup.sh) script accomplishes the following:

    ```bash
    # Setup SSH Key
    ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
    aws ec2 import-key-pair --key-name "eks-workshop" --public-key-material file://~/.ssh/id_rsa.pub
    
    # Install Dependencies
    sudo yum update -y
    sudo yum install -y jq gettext bash-completion moreutils
    curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/aws-iam-authenticator
    sudo mv -v aws-iam-authenticator /usr/local/bin/
    sudo chmod +x /usr/local/bin/aws-iam-authenticator
    
    # Set AWS Environment Variables
    export ACCOUNT_ID=$(aws sts get-caller-identity --output text --query Account) 
    export AWS_REGION=$(curl -s 169.254.169.254/latest/dynamic/instance-identity/document | jq -r '.region') 
    echo "export ACCOUNT_ID=${ACCOUNT_ID}" >> ~/.bash_profile 
    echo "export AWS_REGION=${AWS_REGION}" >> ~/.bash_profile 
    aws configure set default.region "${AWS_REGION}" 
    aws configure get default.region
    
    # Prepare for EC2 Role
    rm -vf "${HOME}/.aws/credentials"
    ```

## Attach EC2 Role to Cloud9 Workspace

1. Disable Cloud9 Temporary Credentials ![role-1](./images/role-1.png)

2. Create EC2 Role ![role-2](./images/role-2.png)

3. Attach EC2 Role to Cloud9 ![role-3](./images/role-3.png)
![role-4](./images/role-4.png)
