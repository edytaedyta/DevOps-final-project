# DevOps Final Project

This repository contains infrastructure code and deployment configuration for a sample Django application running on AWS.  
The project uses Terraform to provision cloud resources, Helm to package the application, Jenkins for CI, Argo CD for GitOps delivery, and Prometheus/Grafana for monitoring.

## What is included

The environment created by this project consists of:

- AWS VPC with public and private subnets
- Amazon EKS cluster for Kubernetes workloads
- Amazon ECR repository for Docker images
- Amazon RDS MySQL database
- Jenkins deployed inside Kubernetes
- Argo CD for continuous delivery
- Prometheus and Grafana for observability
- Django application deployed from a Helm chart

## Repository layout

```text
bootstrap/backend/        bootstrap configuration for Terraform remote state
modules/                  reusable Terraform modules
charts/django-app/        Helm chart for the application
Django/                   Django application source code
backend.hcl.example       example backend configuration
terraform.tfvars.example  example variable file
Deployment steps
1. Bootstrap remote state
cd bootstrap/backend
terraform init
terraform apply

After this step, create backend.hcl based on backend.hcl.example and fill it with the generated backend values.

2. Prepare local configuration
cp backend.hcl.example backend.hcl
cp terraform.tfvars.example terraform.tfvars

Update the placeholders in both files before running the main deployment.

3. Provision infrastructure
terraform init -backend-config=backend.hcl -reconfigure
terraform plan
terraform apply
4. Configure cluster access
aws eks update-kubeconfig --region eu-central-1 --name $(terraform output -raw eks_cluster_name)
5. Verify deployed components
kubectl get all -n jenkins
kubectl get all -n argocd
kubectl get all -n monitoring
6. Access selected services locally
kubectl port-forward svc/jenkins 8080:8080 -n jenkins
kubectl port-forward svc/argocd-server 8081:443 -n argocd
kubectl port-forward svc/kube-prometheus-stack-grafana 3000:80 -n monitoring
CI/CD flow

The expected delivery flow is straightforward:

Code is pushed to the repository.
Jenkins builds a new Docker image for the Django app.
The image is pushed to Amazon ECR.
The Helm chart is updated with the new image tag.
Argo CD detects the Git change and syncs the application to EKS.
Prometheus collects metrics and Grafana exposes dashboards.
Prerequisites

Before running this project, make sure the following tools are available:

Terraform
AWS CLI
kubectl
Helm
access to an AWS account with required permissions
Notes

This repository should contain only sanitized example configuration.
Do not commit real secrets such as:

terraform.tfvars
backend.hcl
passwords
GitHub tokens
private keys
.env files
Cleanup

To destroy the deployed infrastructure:

terraform destroy