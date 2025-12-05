# 🚀 AWS DevOps Project: Scalable Microservice with ECS Fargate + CI/CD + Monitoring

## 📌 Project Overview
This project demonstrates a **production-grade DevOps pipeline** for deploying and managing a containerized Flask microservice on AWS.

It covers:
- Containerization with **Docker**
- Deployment on **AWS ECS Fargate**
- Infrastructure-as-Code with **Terraform**
- CI/CD pipeline using **GitHub Actions (OIDC authentication)**
- Monitoring & logging with **CloudWatch** and **Prometheus + Grafana**
- Auto-scaling with **Application Load Balancer (ALB)** + **ECS Service Auto Scaling**

---

## 🏗️ Architecture Diagram

Users
│
▼
Application Load Balancer (ALB)
│
▼
ECS (Fargate Tasks) ──► CloudWatch Logs
│
└────────► Prometheus (scrapes /metrics) ──► Grafana Dashboards

GitHub Actions ──► ECR ──► ECS (Fargate Deploy)
Terraform ──► VPC, ECS, ECR, ALB, IAM, CloudWatch

yaml
Copy code

Show:
- User traffic → ALB → ECS tasks  
- ECS writing to CloudWatch logs  
- Prometheus scraping `/metrics` and feeding Grafana  
- GitHub Actions pushing images to ECR and updating ECS  
- Terraform as the infra provisioning layer  

---

## 🖥️ Run Locally

1. Clone repo:
   ```bash
   git clone https://github.com/<your-org>/<repo>.git
   cd <repo>
Build Docker image:

bash
Copy code
docker build -t myapp .
Run locally:

bash
Copy code
docker run -p 5000:5000 myapp
Test endpoints:

bash
Copy code
curl http://localhost:5000/health
curl http://localhost:5000/metrics
☁️ Terraform Infrastructure
Terraform files are located in /infra/terraform.

Provisioned resources:

VPC (subnets, route tables, security groups)

ECR Repository (for storing Docker images)

ECS Cluster (Fargate) with Task Definitions and Services

Application Load Balancer (ALB) + Target Groups + Listeners

IAM Roles (Task Execution Role, OIDC Role for CI/CD)

CloudWatch Log Groups

Usage:

bash
Copy code
cd infra/terraform
terraform init
terraform plan
terraform apply
Destroy resources:

bash
Copy code
terraform destroy
🔄 CI/CD Pipeline (GitHub Actions)
Located in .github/workflows/deploy.yml.

Pipeline Flow:

Trigger: push/merge to main.

Build Docker image.

Authenticate to AWS via OIDC (no long-lived AWS keys).

Push image to Amazon ECR.

Update ECS Fargate service with new task definition.

Secrets managed in GitHub:

None needed for AWS creds (OIDC is used).

Optional: app-specific secrets in GitHub → Encrypted Secrets.

📊 Monitoring & Alerts
🔹 CloudWatch
ECS task logs go to /ecs/myapp.

Check logs:

bash
Copy code
aws logs tail /ecs/myapp --follow
🔹 Prometheus + Grafana (via EKS, optional)
Installed with Helm chart kube-prometheus-stack.

Prometheus scrapes /metrics exposed by the app.

Grafana dashboards visualize CPU, memory, and custom app metrics.

Steps:

Deploy app + Service + ServiceMonitor on EKS.

Port-forward Prometheus:

bash
Copy code
kubectl port-forward svc/kube-prometheus-prometheus -n monitoring 9090:9090
Port-forward Grafana:

bash
Copy code
kubectl port-forward svc/kube-prometheus-grafana -n monitoring 3000:80
Login to Grafana (admin / password from secret):

bash
Copy code
kubectl get secret -n monitoring kube-prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 --decode
🧪 Testing Endpoints
Once deployed behind ALB:

bash
Copy code
curl http://<alb-dns>/health
curl http://<alb-dns>/metrics
Local test (via port-forward if using EKS):

bash
Copy code
kubectl port-forward svc/myservice 8080:80
curl http://localhost:8080/metrics
🧹 Teardown / Cleanup
Terraform destroy:

bash
Copy code
cd infra/terraform
terraform destroy
Delete ECR images:

bash
Copy code
aws ecr batch-delete-image \
  --repository-name myapp \
  --image-ids imageTag=latest
Delete CloudWatch logs:

bash
Copy code
aws logs delete-log-group --log-group-name /ecs/myapp
