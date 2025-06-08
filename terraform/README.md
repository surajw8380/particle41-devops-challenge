## Terraform Deployment Guide ##

This directory (`/terraform`) contains all the infrastructure-as-code (IaC) configurations used to deploy the **SimpleTimeService** containerized application on AWS using ECS Fargate, an Application Load Balancer, and supporting cloud resources. It also includes a remote backend setup for managing Terraform state files securely.

---

## 📁 Directory Structure

```
/terraform
│
├── backend.tf                 # Remote backend configuration using S3 & DynamoDB
├── main.tf                    # Main infrastructure provisioning (VPC, ECS, ALB, etc.)
├── outputs.tf                 # Terraform outputs (e.g., ALB DNS)
├── terraform.tfvars           # Variable values used in deployment
├── variables.tf               # Declared variables and default values
│
└── backend-setup/
    └── remote_backend_setup.tf # Creates S3 bucket & DynamoDB table for backend
```

---

## 🛠️ Prerequisites

Before running the Terraform scripts, ensure the following tools are installed:

* **Terraform** (>= 1.3.0): [Install Terraform](https://developer.hashicorp.com/terraform/downloads)
* **AWS CLI**: [Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
* An **AWS Account** with programmatic access
* An **IAM user/role** with the following permissions:

### IAM Policy 

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:*",
        "ecs:*",
        "elasticloadbalancing:*",
        "iam:CreateRole",
        "iam:DeleteRole",
        "iam:PassRole",
        "iam:AttachRolePolicy",
        "iam:DetachRolePolicy",
        "iam:GetRole",
        "iam:ListRoles",
        "logs:*",
        "cloudwatch:*",
        "autoscaling:*",
        "servicediscovery:*",
        "ssm:GetParameter",
        "ssm:GetParameters",
        "ssm:DescribeParameters"
      ],
      "Resource": "*"
    }
  ]
}
```

---

## 🔐 AWS Authentication

Configure AWS CLI with your IAM credentials:

```bash
aws configure
```

Provide the following details:

* AWS Access Key ID
* AWS Secret Access Key
* Default region name (e.g., `ap-south-1`)
* Default output format (optional)

Terraform will use these credentials automatically.

---

## 🏗️ Step-by-Step Deployment

### 1. Remote Backend Setup

This step sets up an S3 bucket and DynamoDB table for state management.

```bash
cd terraform/backend-setup
terraform init
terraform plan
terraform apply
```

### 2. Main Infrastructure Deployment

Provision ECS, ALB, VPC, Security Groups, and supporting resources.

```bash
cd ../  # Go back to /terraform
terraform init
terraform plan
terraform apply
```

### 3. Access the Application

Once deployed successfully, Terraform will output the ALB DNS.
Open it in your browser to see the response from the containerized Flask app.

---

## 🔁 Destroying Infrastructure

To destroy all resources:

### 1. Destroy ECS and ALB Resources

```bash
cd terraform/
terraform destroy
```

### 2. Destroy Remote Backend Setup

```bash
cd backend-setup/
terraform destroy
```

---

## 📌 Terraform Highlights

* **Modules Used**:

  * [terraform-aws-modules/vpc/aws](https://github.com/terraform-aws-modules/terraform-aws-vpc)
* **ECS Configuration**:

  * Uses Fargate launch type
  * Task defined with port `5000` for Flask app
* **Load Balancer**:

  * ALB configured to route HTTP traffic to ECS
* **Security**:

  * Security groups restrict traffic to necessary ports only

---

## 📄 Variables Overview

| Variable         | Description                   | Example Value                          |
| ---------------- | ----------------------------- | -------------------------------------- |
| aws_region      | AWS Region to deploy to       | `ap-south-1`                           |
| project_name    | Prefix for all resource names | `simpletime`                           |
| vpc_cidr        | VPC CIDR block                | `10.0.0.0/16`                          |
| public_subnets  | Public subnet CIDRs           | `["10.0.1.0/24", "10.0.2.0/24"]`       |
| private_subnets | Private subnet CIDRs          | `["10.0.3.0/24", "10.0.4.0/24"]`       |
| container_image | Docker image used in ECS      | `suraj838098/simpletimeservice:latest` |
| container_port  | Port your app listens on      | `5000`                                 |
| task_cpu        | ECS task CPU allocation       | `256`                                  |
| task_memory     | ECS task memory allocation    | `512`                                  |

---

## ✅ Outputs

* `load_balancer_dns`: DNS of the public ALB to access the app.

---

## 📌 Notes

* Ensure S3 and DynamoDB names are unique globally.
* Always destroy backend setup after destroying the infrastructure to avoid dangling backend resources.
* Uses public and private subnets for high availability.

---


