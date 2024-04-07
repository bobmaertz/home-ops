variable proxmox_user_password {
    type = string 
    sensitive = true
    description = "Proxmox Node User Password"
}

variable proxmox_user_name {
    type = string 
    sensitive = true
    description = "Proxmox Node User Name"
}

variable proxmox_endpoint {
    type = string 
    default = "http://10.10.10.10:8006/"
    description = "IP Address + Port for Proxmox node"
}


variable "gateway" {
    type = string 
}

variable "template_name" {
    type = string 
}

variable "dns_nameservers" {
    type = list(string)
    default = [
        "1.1.1.1",
        "8.8.8.8"
    ]
}