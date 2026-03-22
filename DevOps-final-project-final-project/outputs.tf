output "aws_account_id" {
  description = "AWS account ID detected from the currently authenticated caller"
  value       = data.aws_caller_identity.current.account_id
}

output "ecr_repository_url" {
  description = "Full Amazon ECR repository URL for the Django application image"
  value       = module.ecr.repository_url
}

output "eks_cluster_name" {
  description = "Amazon EKS cluster name"
  value       = module.eks.cluster_name
}

output "rds_endpoint" {
  description = "Primary RDS endpoint hostname"
  value       = module.rds.endpoint
}

output "rds_port" {
  description = "Primary RDS port"
  value       = module.rds.port
}

output "jenkins_admin_password" {
  description = "Initial Jenkins administrator password"
  value       = module.jenkins.admin_password
  sensitive   = true
}

output "argocd_initial_admin_password" {
  description = "Initial Argo CD admin password"
  value       = module.argo_cd.initial_admin_password
  sensitive   = true
}

output "grafana_admin_password" {
  description = "Grafana admin password generated for the monitoring stack"
  value       = module.monitoring.grafana_admin_password
  sensitive   = true
}
