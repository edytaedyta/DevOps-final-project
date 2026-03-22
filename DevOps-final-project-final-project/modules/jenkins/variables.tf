variable "namespace" { type = string default = "jenkins" }
variable "chart_version" { type = string default = "5.8.12" }
variable "aws_region" { type = string }
variable "ecr_repository_url" { type = string }
variable "git_repository_url" { type = string }
variable "git_repository_branch" { type = string }
variable "git_username" { type = string }
variable "git_token" { type = string sensitive = true }
variable "tags" { type = map(string) default = {} }
