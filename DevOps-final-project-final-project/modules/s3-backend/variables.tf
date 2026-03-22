variable "bucket_name" {
  type        = string
  description = "S3 bucket for Terraform state"
}

variable "dynamodb_table_name" {
  type        = string
  description = "DynamoDB table for state locking"
}

variable "tags" {
  type    = map(string)
  default = {}
}
