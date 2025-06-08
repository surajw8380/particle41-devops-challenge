# SimpleTimeService – DevOps Challenge Project

## 📌 Project Overview

This project is developed as part of the **Particle41 DevOps Challenge**. It includes a lightweight Python web service containerized using Docker and deployed to **AWS ECS Fargate** using **Terraform**. The infrastructure is fully provisioned with Terraform and leverages an **Application Load Balancer**, **VPC**, **S3 remote state backend**, and **DynamoDB** for state locking.

The service returns the current timestamp and the client's IP address via a simple RESTful endpoint (`GET /`).

---

## 🧾 Table of Contents

* [Features](#features)
* [Architecture](#architecture)
* [Directory Structure](#directory-structure)
* [Prerequisites](#prerequisites)
* [Setup Instructions](#setup-instructions)
* [Infrastructure Overview](#infrastructure-overview)
* [Application Overview](#application-overview)
* [IAM Policy](#iam-policy)
* [Destroying the Infrastructure](#destroying-the-infrastructure)
* [Notes](#notes)

---

## ✅ Features

* Fully containerized Flask app (Python 3.11)
* Infrastructure-as-Code with Terraform
* Remote Terraform backend with S3 & DynamoDB
* Secure, scalable deployment on ECS Fargate
* Public access via Application Load Balancer
* Modular and reusable Terraform code

---

## 🧱 Architecture

```bash
┌───────────────┐
│   User        │
└──────┬────────┘
       │ HTTP
┌──────▼────────┐
│ Application   │
│ Load Balancer │◄────────── ALB SG
└──────┬────────┘
       │
┌──────▼────────────┐
│ ECS Fargate Task  │◄────────── ECS SG
│ (Flask App)       │
└──────┬────────────┘
       │
┌──────▼────────────┐
│ VPC (2 AZs)       │
│ - Public/Private  │
│ - Subnets         │
└───────────────────┘
```

---

## 📁 Directory Structure

```
particle41-devops-challenge/
│
├── app/                     # Flask application and Dockerfile
│   ├── app.py
│   ├── Dockerfile
│   └── requirements.txt
│   └── README.md            # App-specific documentation
│
├── terraform/               # Infrastructure-as-Code
│   ├── backend.tf
│   ├── backend-setup/       # Remote backend (S3 + DynamoDB)
│   │   └── remote_backend_setup.tf
│   ├── main.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   ├── outputs.tf
│   └── README.md            # Terraform usage documentation
│
└── README.md                # Project level documentation
```

---

## ⚙️ Prerequisites

Ensure the following tools are installed:

| Tool      | Version  | Installation Link                                                                      |
| --------- | -------- | -------------------------------------------------------------------------------------- |
| Terraform | >= 1.3.0 | [Install Terraform](https://developer.hashicorp.com/terraform/downloads)               |
| Docker    | >= 20.10 | [Install Docker](https://docs.docker.com/get-docker/)                                  |
| AWS CLI   | >= 2.0   | [Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) |
| Python    | >= 3.11  | [Install Python](https://www.python.org/downloads/)                                    |

## 🔐 AWS Credentials Configuration

Make sure your AWS credentials are configured either via:

### Option 1: AWS CLI Configuration

```bash
aws configure
Set:

AWS Access Key ID

AWS Secret Access Key

Default region (e.g., ap-south-1)

Option 2: Environment Variables
export AWS_ACCESS_KEY_ID=your-access-key
export AWS_SECRET_ACCESS_KEY=your-secret-key
export AWS_DEFAULT_REGION=ap-south-1


---

## 🚀 Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/surajw8380/particle41-devops-challenge.git
cd particle41-devops-challenge
```

### 2. Create Remote Backend (S3 & DynamoDB)

```bash
cd terraform/backend-setup
terraform init
terraform plan
terraform apply
```

### 3. Deploy Main Infrastructure

```bash
cd ../
terraform init
terraform plan
terraform apply
```

### 4. Access the Application

Once deployed, Terraform will output the public ALB URL:

```bash
Outputs:
load_balancer_dns = http://<your-alb-dns>
```

Visit the URL in your browser. You should see:

```json
{
  "timestamp": "2025-06-08T10:35:20.123456",
  "ip": "123.45.67.89"
}
```

---

## 🛠️ Infrastructure Overview

The Terraform code provisions the following AWS resources:

* **VPC** with public and private subnets across 2 AZs
* **Internet Gateway**, **Route Tables**, NAT Gateway
* **Security Groups** for ALB and ECS
* **ALB (Application Load Balancer)**
* **Target Group & Listener**
* **ECS Cluster**
* **ECS Task Definition** (Fargate)
* **ECS Service** with Load Balancer integration
* **IAM Role for ECS Tasks**
* **S3 Bucket** for Terraform backend
* **DynamoDB Table** for state locking

---

## 🐍 Application Overview

The Flask app is located in `app/`.

* **app.py** serves a single GET route `/`
* **Dockerfile** builds a minimal Python image with non-root user
* **Port 5000** is exposed and connected to ALB
* Docker image used: `suraj838098/simpletimeservice:latest`

Example response:

```json
{
  "timestamp": "2025-06-08T11:20:00",
  "ip": "203.0.113.1"
}
```

---

## 🔐 IAM Policy Used

You can use the below IAM policies to provision resources.

<details>
<summary> IAM Policy</summary>

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

</details>



</details>

---

## 🧹 Teardown Instructions

### Destroy Infrastructure

```bash
cd terraform/
terraform destroy
```

Once complete, destroy the backend setup:

```bash
cd backend-setup/
terraform destroy
```

---

## 💡 Notes

* The Docker image is public and hosted on Docker Hub.
* Application is exposed publicly via ALB and deployed in private subnets.
* Remote backend enables team collaboration and state locking.
* Clean separation of concerns between app code and infrastructure.

---


---

> **Author:** Suraj Waghamare
> **Email** surajnm.waghmare@gmail.com

---

