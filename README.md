
# Parrot DevOps Challenge IaC Project Documentation

## Introduction

The Parrot DevOps Challenge project is designed to automate and deploy a backend API using Terraform for Infrastructure as Code (IaC). The project involves creating a CI/CD pipeline, deploying services on AWS ECS, managing secrets, and setting up a frontend using S3 and CloudFront. This document provides an overview of the project's structure, key components, and the Terraform configurations used.

## Project Structure

The project is organized into several Terraform configuration files, each responsible for different aspects of the infrastructure:

### 1. Networking Configuration (`networking.tf`)
This configuration sets up the VPC, subnets, internet gateway, and NAT gateway.

- **VPC**: Defines the Virtual Private Cloud for the project.
- **Subnets**: Includes public and private subnets distributed across availability zones.
- **Internet Gateway**: Allows communication between the VPC and the internet.
- **NAT Gateway**: Provides internet access for resources in the private subnets.
- **Route Tables**: Configures routing for the public and private subnets.

### 2. ECS Configuration (`ecs.tf`)
This configuration sets up the ECS cluster and associated IAM roles.

- **ECS Cluster**: Defines the ECS cluster to run containerized applications.
- **IAM Roles**: Includes roles and policies necessary for ECS task execution.
- **Security Groups**: Manages network access to ECS services.

### 3. Hello World Service (`hello_world.tf`)
This configuration sets up the ECS service for the hello-world application, the related load balancer, and security groups.

- **ECS Task Definition**: Defines the task for the hello-world application.
- **ECS Service**: Manages the deployment and scaling of the hello-world task.
- **Load Balancer**: Distributes traffic to the ECS service.
- **Security Groups**: Ensures secure access to the ECS service.

### 4. Parrot DevOps Challenge API (`parrot_devops_challenge_api.tf`)
This configuration sets up the ECS service for the main API, the related load balancer, security groups, and the ECR repository.

- **ECR Repository**: Stores Docker images for the API.
- **ECS Task Definition**: Defines the task for the main API.
- **ECS Service**: Manages the deployment and scaling of the API task.
- **Load Balancer**: Distributes traffic to the API service.
- **Security Groups**: Ensures secure access to the API service.

### 5. Parrot WebApp (`parrot_webapp.tf`)
This configuration sets up the S3 bucket and CloudFront distribution for the frontend.

- **S3 Bucket**: Stores the frontend static files.
- **CloudFront Distribution**: Provides a CDN for the frontend, ensuring fast delivery of content.
- **Bucket Policies**: Manages access control for the S3 bucket.

### 6. Jenkins Configuration (`jenkins.tf`)
This configuration sets up the bastion server (Jenkins host).

- **Security Group**: Manages access to the Jenkins server.
- **EC2 Instance**: Defines the Jenkins server.

### 7. RDS Configuration (`rds.tf`)
This configuration sets up the RDS PostgreSQL instance.

- **Security Group**: Manages access to the RDS instance.
- **RDS Instance**: Defines the PostgreSQL database.
- **Subnet Group**: Specifies the subnets for the RDS instance.

## Makefile

The Makefile provides commands to initialize and manage the Terraform project. Here are the key commands:

- `init`: Initializes the Terraform project.
- `get-secrets`: Fetches necessary secrets.
- `commit`: Retrieves commit information.
- `plan`: Plans the Terraform changes.
- `apply`: Applies the Terraform changes.
- `refresh`: Refreshes the Terraform state.
- `destroy`: Destroys the Terraform-managed infrastructure.
- `graph`: Generates a dependency graph of the infrastructure.

## Deployment Steps

1. **Initialize the Terraform Project**:
   ```sh
   make init
   ```

2. **Fetch Secrets**:
   ```sh
   make get-secrets
   ```

3. **Plan the Terraform Changes**:
   ```sh
   make plan
   ```

4. **Apply the Terraform Changes**:
   ```sh
   make apply
   ```

5. **Generate the Infrastructure Graph**:
   ```sh
   make graph
   ```

6. **Destroy the Infrastructure**:
   ```sh
   make destroy
   ```