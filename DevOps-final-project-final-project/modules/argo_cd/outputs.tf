output "initial_admin_password" {
  value     = data.kubernetes_secret.initial.data["password"]
  sensitive = true
}
