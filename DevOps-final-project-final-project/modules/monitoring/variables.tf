variable "namespace" { type = string default = "monitoring" }
variable "chart_version" { type = string default = "58.6.0" }
variable "tags" { type = map(string) default = {} }
