output "operations_automation_user_password" {
  value     = random_password.operations_automation_user_password.result
  sensitive = true
}