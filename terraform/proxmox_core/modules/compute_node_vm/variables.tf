variable "template" {
  type    = string
  default = "ubuntu-2204-cloudinit-template"
}

variable "start_id" {
  type        = number
  default     = 1000
  description = "starting integer for the vmids"
}

variable "gateway" {
  type    = string
  default = "192.168.3.1"
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
    max_memory   = number,
    min_memory   = number,
    disk_size    = string,
    datastore_id = string,
    bridge       = string,
  }))
}


