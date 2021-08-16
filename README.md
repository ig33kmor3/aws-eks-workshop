# AWS Elastic Kubernetes Service (EKS) Workshop

This workshop is designed to help users learn Kubernetes on AWS using EKS. To start, download project to working directory:

```bash
git clone https://github.com/ig33kmor3/aws-eks-workshop.git
```

## [Project Setup - Lab 0](./0-setup)

Prepare your Cloud9 Workspace to interact with AWS EKS by installing the required utilities.

## [Launching an EKS Cluster - Lab 1](./1-launching-eks-cluster)

Deploy an EKS cluster using [eksctl](https://eksctl.io/).

## [Preparing EKS Cluser for Applications - Lab 2](./2-preparing-eks-cluster )

Execute the following:

* Verify AWS Load Balancer IAM roles for service account is configured
* Deploy AWS Load Balancer Controller for external connectivity
* Deploy official Kubernetes dashboard

## [Containerize Tomcat Web Application - Lab 3](./3-containerize-web-application)

Securely containerize a Java Spring Boot MVC application with Tomcat Servlet for deployment into the cluster. Push containerized application to AWS Elastic Container Registry (ECR).

![airport-data](./3-containerize-web-application/airplane-data/app.png)

## [Deploying Application to EKS Cluster - Lab 4](./4-deploying-application-into-eks)

Deploy the above containerized application from ECR into the newly formed EKS cluster.

## [Update Deployment on EKS Cluster - Lab 5](./5-update-application-deployment)

Update the containerized application by adding additional airports then containerize a new version for upload to ECR.
