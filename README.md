# Comprehensive Terraform AWS Project Guide

1. [Project Overview](#1-project-overview)
2. [Infrastructure Design](#2-infrastructure-design)
3. [Deployment Guide](#3-deployment-guide)
4. [Best Practices and Security](#4-best-practices-and-security)
5. [Troubleshooting and Monitoring](#5-troubleshooting-and-monitoring)

---

## 1. Project Overview

This project demonstrates the deployment of a scalable multi-tier web application using Terraform and AWS. It includes:

- **Infrastructure as Code (IaC):** Managed with Terraform.
- **Web and Application Tiers:** Dockerized Flask app and Nginx web server.
- **Database Tier:** AWS RDS (MySQL) instance.
- **Networking:** Custom VPC, subnets, security groups, and ALB (Application Load Balancer).

### Key Features:
- Modularized Terraform code.
- Docker containerization.
- S3 backend for Terraform state management.
- Automated deployment scripts.

---

## 2. Infrastructure Design

### Architecture Components:

1. **VPC (Virtual Private Cloud):**
   - CIDR block: `10.0.0.0/16`
   - 2 public subnets and 2 private subnets.

2. **EC2 Instances:**
   - Two instances: Web server and application server.
   - Configured with AWS SSM for management.

3. **RDS (Relational Database Service):**
   - MySQL database.
   - Encrypted at rest and in transit.

4. **ALB (Application Load Balancer):**
   - Distributes traffic to EC2 instances.
   - Health checks configured for reliability.

5. **Dockerized Applications:**
   - Flask app: Backend application.
   - Nginx: Serves as the web server.

6. **Networking and Security:**
   - Security groups enforce least privilege access.
   - NAT Gateway for private subnet internet access.

---

## 3. Deployment Guide

### Prerequisites:
- Terraform installed ([Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)).
- AWS CLI configured with appropriate credentials.
- Docker installed ([Install Docker](https://docs.docker.com/get-docker/)).

### Steps:

#### 1. Clone the Repository
```bash
git clone https://github.com/your-repo/terraform-aws-project.git
cd terraform-aws-project
```

#### 2. Initialize Terraform
```bash
terraform init
```

#### 3. Plan Infrastructure
```bash
terraform plan -var-file=secrets.tfvars
```

#### 4. Apply Configuration
```bash
terraform apply -var-file=secrets.tfvars
```

#### 5. Build and Start Docker Containers
For the application server:
```bash
cd docker/app
docker build -t flask-app .
docker run -d -p 8080:80 flask-app
```
For the web server:
```bash
cd docker/web
docker build -t nginx-web .
docker run -d -p 80:80 nginx-web
```

---

## 4. Best Practices and Security

### Best Practices:
- **State Management:** Use remote backend (S3) with encryption enabled for Terraform state.
- **Modules:** Modularize Terraform configurations for reusability and maintainability.
- **Versioning:** Pin versions for Terraform providers and modules.

### Security Enhancements:
1. **Secrets Management:**
   - Use AWS Secrets Manager to store sensitive variables like `db_password`.

2. **Networking:**
   - Restrict `0.0.0.0/0` in security groups. Allow access only from trusted CIDR blocks.

3. **IAM Roles:**
   - Enforce least privilege for IAM roles and policies.

4. **Docker:**
   - Use non-root users in containers for enhanced security.
   - Regularly scan images with tools like Trivy.

5. **RDS:**
   - Enable automatic backups and multi-AZ deployments for high availability.

---

## 5. Troubleshooting and Monitoring

### Common Issues:
1. **Terraform Errors:**
   - Missing AWS credentials: Ensure `~/.aws/credentials` is correctly configured.
   - State file lock: Check S3 bucket locks and release them if stuck.

2. **EC2 Instances:**
   - SSH access issues: Ensure your IP is whitelisted in the security group.
   - Docker not running: Verify Docker installation and service status.

3. **RDS Connectivity:**
   - Ensure EC2 security group allows inbound traffic on port 3306.

### Monitoring Tools:

#### AWS CloudWatch Example:
- **Set an Alarm for High CPU Utilization:**
```bash
aws cloudwatch put-metric-alarm \
  --alarm-name "High-CPU-Utilization" \
  --metric-name "CPUUtilization" \
  --namespace "AWS/EC2" \
  --statistic "Average" \
  --dimensions Name=InstanceId,Value=<your-instance-id> \
  --threshold 80 \
  --comparison-operator GreaterThanThreshold \
  --evaluation-periods 2 \
  --period 60 \
  --alarm-actions <action-arn>
```
- Replace `<your-instance-id>` with the EC2 instance ID and `<action-arn>` with an ARN for an SNS topic or other notification service.

#### Prometheus Example:
- **Monitor Memory Usage:**
  - Install Node Exporter on your EC2 instance.
  - Use the following PromQL query to visualize memory utilization:
    ```promql
    node_memory_Active_bytes / node_memory_MemTotal_bytes * 100
    ```
  - This shows the percentage of active memory usage.

#### Grafana Example:
- Create a new dashboard and add Prometheus as a data source.
- Add a panel with the CPU and memory queries for visualization.

---

