#!/bin/bash

echo "Setup SSH Key ..." && sleep 1
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
aws ec2 import-key-pair --key-name "eks-workshop" --public-key-material file://~/.ssh/id_rsa.pub
printf "\n"

echo "Install Dependencies ..." && sleep 1
sudo yum update -y
sudo yum install -y jq gettext bash-completion moreutils
curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/aws-iam-authenticator
sudo mv -v aws-iam-authenticator /usr/local/bin/
sudo chmod +x /usr/local/bin/aws-iam-authenticator
printf "\n"

echo "Set AWS Environment Variables ..." && sleep 1
export ACCOUNT_ID=$(aws sts get-caller-identity --output text --query Account) 
export AWS_REGION=$(curl -s 169.254.169.254/latest/dynamic/instance-identity/document | jq -r '.region') 
echo "export ACCOUNT_ID=${ACCOUNT_ID}" >> ~/.bash_profile 
echo "export AWS_REGION=${AWS_REGION}" >> ~/.bash_profile 
aws configure set default.region ${AWS_REGION} 
aws configure get default.region
printf "\n"

echo "Prepare for EC2 Role ..." && sleep 1
rm -vf ${HOME}/.aws/credentials
