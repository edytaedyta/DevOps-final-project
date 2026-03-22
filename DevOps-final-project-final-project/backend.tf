# 1) First create the backend using: cd bootstrap/backend && terraform apply
# 2) Copy real names from outputs into backend.hcl
# 3) Run: terraform init -backend-config=backend.hcl -reconfigure
terraform {
  backend "s3" {}
}
