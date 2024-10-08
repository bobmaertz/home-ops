variable "proxmox_user_password" {
  type        = string
  sensitive   = true
  description = "Proxmox Node User Password"
}

variable "proxmox_user_name" {
  type        = string
  sensitive   = true
  description = "Proxmox Node User Name"
}

variable "proxmox_endpoint" {
  type        = string
  description = "IP Address + Port for Proxmox node"
}
