variable "start_id" {
  type        = number
  default     = 1000
  description = "starting integer for the vmids"
}

variable "gateway" {
  type = string
}

variable "ssh_pub_key_file" {
  type = string
}

variable "node_name" {
  type = string
}

variable "datastore_id" {
  type = string
}

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
  default     = "http://10.10.10.10:8006/"
  description = "IP Address + Port for Proxmox node"
}

variable "vms" {
  type = list(object({
    name         = string,
    cores        = number,
    sockets      = number,
    min_memory   = number,
    disk_size    = string,
    datastore_id = string,
    bridge       = string,
    ip_address   = string,
  }))
}


