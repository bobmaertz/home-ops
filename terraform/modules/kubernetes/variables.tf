variable "pubkey" {
  type = string 
}

variable "pvtkey" {
  type = string 
}

variable "template" {
    type = string 
    default = "ubuntu-2004-cloudinit-template"
}

variable "start_id" {
  type = number 
}

variable "gateway" {
  type = string 
}

variable "datastoreId" {
  type = string 
}

variable "proxmox" {
  type = object({
    username = string,
    password = string,
    endpoint = string,
  })
}

variable "hosts" {
  type = list(object({
    mac_address = string,
    hostname    = string,
    hastate     = string,
    node        = string,
    ip      = string, 
  }))
}

variable "specs" {
  type = object({
    cores   = number,
    sockets = number,
    max_memory  = number,
    min_memory = number,
    storage = string,
    size    = string,
    bridge  = string,
  })
}

