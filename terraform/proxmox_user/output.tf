output "operations_automation_user_password" {
  value     = random_password.operations_automation_user_password.result
  sensitive = true
}
output "pve-exporter-password" {
  value     = random_password.pve-exporter-password.result
  sensitive = true
}


