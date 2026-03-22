variable "aws_region" {
  type        = string
  description = "AWS region used for all infrastructure resources"
  default     = "eu-central-1"
}

variable "project_name" {
  type        = string
  description = "Project prefix used in naming AWS and Kubernetes resources"
  default     = "goit-devops-final"
}

variable "environment" {
  type        = string
  description = "Deployment environment name"
  default     = "dev"
}

variable "tags" {
  type        = map(string)
  description = "Common resource tags applied across the project"
  default = {
    Course    = "GOIT DevOps"
    Owner     = "DevOps Student"
    ManagedBy = "terraform"
  }
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the main project VPC"
  default     = "10.20.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR ranges for public subnets"
  default     = ["10.20.1.0/24", "10.20.2.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDR ranges for private subnets used by EKS nodes and RDS"
  default     = ["10.20.11.0/24", "10.20.12.0/24"]
}

variable "cluster_version" {
  type        = string
  description = "Amazon EKS Kubernetes version"
  default     = "1.29"
}

variable "node_instance_types" {
  type        = list(string)
  description = "Instance types used by the managed node group"
  default     = ["t3.medium"]
}

variable "db_use_aurora" {
  type        = bool
  description = "Whether to create an Aurora cluster instead of a single RDS instance"
  default     = false
}

variable "db_engine" {
  type        = string
  description = "Database engine used for the relational database layer"
  default     = "mysql"
}

variable "db_engine_version" {
  type        = string
  description = "Database engine version"
  default     = "8.0"
}

variable "db_instance_class" {
  type        = string
  description = "RDS instance class"
  default     = "db.t3.micro"
}

variable "db_multi_az" {
  type        = bool
  description = "Enable Multi-AZ deployment for the RDS instance"
  default     = false
}

variable "db_name" {
  type        = string
  description = "Application database name"
  default     = "appdb"
}

variable "db_username" {
  type        = string
  description = "Application database user name"
  default     = "app_user"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Database password used by the sample Django application"
}

variable "git_repository_url" {
  type        = string
  description = "HTTPS Git repository URL used by both Jenkins and Argo CD"
}

variable "git_repository_branch" {
  type        = string
  description = "Target Git branch monitored by Argo CD and updated by Jenkins"
  default     = "main"
}

variable "charts_repo_path" {
  type        = string
  description = "Path inside the repository where the Helm chart is stored"
  default     = "charts/django-app"
}

variable "git_username" {
  type        = string
  description = "Git username used by Jenkins for automated chart updates"
  default     = ""
}

variable "git_token" {
  type        = string
  sensitive   = true
  description = "Personal access token used by Jenkins to push chart updates"
  default     = ""
}
