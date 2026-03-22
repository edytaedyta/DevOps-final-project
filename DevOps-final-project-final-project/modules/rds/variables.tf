variable "project_name" { type = string }
variable "use_aurora" { type = bool default = false }
variable "engine" { type = string default = "mysql" }
variable "engine_version" { type = string default = "8.0" }
variable "instance_class" { type = string default = "db.t3.micro" }
variable "multi_az" { type = bool default = false }

variable "allocated_storage" { type = number default = 20 }
variable "storage_type" { type = string default = "gp3" }

variable "db_name" { type = string default = "appdb" }
variable "username" { type = string default = "admin" }
variable "password" { type = string sensitive = true }
variable "port" { type = number default = 3306 }

variable "vpc_id" { type = string }
variable "subnet_ids" { type = list(string) }
variable "allowed_cidrs" { type = list(string) default = [] }

variable "parameter_overrides" { type = map(string) default = {} }
variable "tags" { type = map(string) default = {} }

variable "aurora_engine" {
  type        = string
  description = "aurora-mysql or aurora-postgresql (used only when use_aurora=true)"
  default     = "aurora-mysql"
}
