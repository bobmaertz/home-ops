variable "runner_repos" {
  description = "List of repository names (under bobmaertz) that use the self-hosted-orion runner."
  type        = list(string)
  default     = []
}

variable "registry_username" {
  description = "Username for registry.bou1der.net. Injected as REGISTRY_USERNAME secret into each runner repo."
  type        = string
  sensitive   = true
}

variable "registry_password" {
  description = "Password for registry.bou1der.net. Injected as REGISTRY_PASSWORD secret into each runner repo."
  type        = string
  sensitive   = true
}
