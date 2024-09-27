# Minecraft Server on AWS ECS Fargate with Terraform

This repository contains Terraform code to deploy a fully functional Minecraft server on AWS using ECS Fargate, backed by an EFS file system for persistent data storage. The server is exposed to the internet via a Network Load Balancer (NLB) and can be accessed using a custom domain name configured in Route 53.

## Architecture Overview

- AWS VPC: A new Virtual Private Cloud with public subnets across multiple Availability Zones.
- ECS Fargate: Runs the Dockerized Minecraft server without managing EC2 instances.
- EFS (Elastic File System): Provides persistent storage for Minecraft world data.
- NLB (Network Load Balancer): Distributes incoming TCP traffic on port 25565 to the ECS tasks.
- Route 53: Configures DNS to route traffic to the NLB using a custom domain.
- IAM Roles: Manages permissions for ECS tasks to interact with AWS services.

## Prerequisites

- Terraform: Version 0.12 or higher.
- AWS Account: With permissions to create the resources mentioned.
- Domain Name: A registered domain that you can manage DNS records for.
- AWS CLI: Configured with credentials (`aws configure`).

## Getting Started

### 1. Clone the Repository

```
git clone https://github.com/yourusername/minecraft-ecs-terraform.git
cd minecraft-ecs-terraform
```

### 2. Configure AWS Credentials

Ensure your AWS CLI is configured with credentials that have the necessary permissions.

```
aws configure
```

### 3. Update Variables

Edit the `variables.tf` file to set your AWS region, domain name, and other configurations.

```
variable "aws_region" {
  description = "AWS region to deploy the resources"
  default     = "ap-northeast-1"
}

variable "domain_name" {
  description = "Your registered domain name (e.g., example.com)"
  type        = string
  default     = "FIXME"
}

variable "hosted_zone_id" {
  description = "hosted zone id"
  type        = string
  default     = "FIXME"
}
```

### 4. Initialize Terraform & Apply

Initialize the Terraform workspace.
Review the plan and apply the changes.

```
terraform init
terraform plan
terraform apply
```

Type `yes` when prompted to confirm the creation of resources.

### 5. Update DNS Settings

After Terraform applies successfully:

- Route 53 Nameservers: If a new Route 53 Hosted Zone was created, update your domain registrar to point to the Route 53 nameservers.
- Wait for DNS Propagation: It may take some time for DNS changes to propagate.

### 6. Connect to Your Minecraft Server

Open your Minecraft client and connect using your domain name (e.g., `minecraft.example.com`).

## File Structure

- provider.tf: Configures the AWS provider.
- variables.tf: Defines input variables.
- vpc.tf: Sets up VPC, subnets, and internet gateway.
- security_group.tf: Defines security groups for ECS tasks and EFS.
- efs.tf: Configures the EFS file system and access point.
- ecs.tf: Creates the ECS cluster, service and task_definition.
- iam.tf: Sets up IAM roles and policies.
- nlb.tf: Configures the Network Load Balancer.
- route53.tf: Sets up Route 53 DNS records.
- cloudwatch.tf: (Optional) Configures CloudWatch Logs for monitoring.
- main.tf: Sets up terraform backend.

## Customization

- Server Properties: Modify the `environment` section in `ecs.tf` to customize server settings.
- Resource Sizes: Adjust `cpu` and `memory` in the task definition to allocate more resources.
- Scaling: Modify desired_count in `ecs.tf` to run multiple instances.

## Clean Up

To delete all resources created by Terraform:

```
terraform destroy
```

Type yes when prompted to confirm the destruction.



## License

This project is licensed under the MIT License.

## Acknowledgments

- itzg/minecraft-server: The Docker image used for running the Minecraft server.
- Terraform AWS Modules: Inspiration and best practices for AWS resource management.