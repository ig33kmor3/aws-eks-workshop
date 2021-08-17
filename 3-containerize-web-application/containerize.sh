#!/bin/bash

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
