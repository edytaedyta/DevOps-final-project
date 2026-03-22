variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "project_name" {
  type    = string
  default = "final-devops"
}

variable "tags" {
  type    = map(string)
  default = {}
}
