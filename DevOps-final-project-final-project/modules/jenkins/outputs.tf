output "admin_password" {
  value     = data.kubernetes_secret.admin.data["jenkins-admin-password"]
  sensitive = true
}
