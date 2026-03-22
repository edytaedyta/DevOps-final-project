variable "namespace" {
  type    = string
  default = "argocd"
}

variable "chart_version" {
  type    = string
  default = "7.7.15"
}

variable "charts_repo_url" {
  type        = string
  description = "Git repository URL watched by Argo CD"
}

variable "charts_repo_path" {
  type        = string
  description = "Path to the application Helm chart inside the Git repository"
}

variable "git_repository_branch" {
  type        = string
  description = "Git branch used by the GitOps workflow"
}

variable "ecr_repository_url" {
  type        = string
  description = "Container image repository URL consumed by the application chart"
}

variable "image_tag" {
  type        = string
  description = "Application image tag rendered into the Helm release values"
}

variable "db_host" {
  type        = string
  description = "Application database host passed to the Helm values"
}

variable "db_port" {
  type        = string
  description = "Application database port"
}

variable "db_name" {
  type        = string
  description = "Application database name"
}

variable "db_user" {
  type        = string
  description = "Application database user"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Application database password"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Common labels and tags"
}
