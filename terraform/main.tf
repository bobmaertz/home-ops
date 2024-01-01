//TODO: Remove the local and use environment variables instead
// Most of this can be done with the terraform.tfvars file
locals {
  config = yamldecode(file("${path.module}/config.yaml"))
}

# output "out" {
#   value = local.config
# }

# output "vm_private_key" {
#   value = module.services.vm_private_key
#   sensitive = true 
# }

# output "vm_public_key" {
#   value = module.services.vm_public_key
#   sensitive = true 
# }

# output "vm_password" {
#   value = module.services.vm_password
#   sensitive = true 
# }

module "services" {
  source = "./modules/proxmox"

  datastoreId = "synology-nas-backup"

  proxmox = {
    username = local.config.proxmox.user
    password = local.config.proxmox.password
    endpoint = local.config.proxmox.endpoint
  }

  template = "ubuntu-2004-cloudinit-template"
  start_id = 5000

  gateway = local.config.gateway

  hosts = [
    {
      hostname    = "home-services"
      mac_address = "BD-EC-8D-37-9A-DE"
      hastate     = "started"
      node        = "curiosity"
      ip          = "192.168.1.161"
    },
    # {
    #   hostname    = "home-proxy"
    #   mac_address = "D4-1C-80-17-51-8E"
    #   hastate     = "started"
    #   node        = "curiosity"
    #   ip          = "192.168.1.162"
    # }
  ]

  specs = {
    bridge     = "vmbr0"
    cores      = 2
    min_memory = 4096
    max_memory = 12288
    size       = "20"
    sockets    = 1
    storage    = "vm_pool"
  }

}

# module "k8s" {
#   source = "./modules/proxmox"

#   datastoreId = "synology-nas-backup"

#   proxmox = {
#     username = local.config.proxmox.user
#     password = local.config.proxmox.password
#     endpoint = local.config.proxmox.endpoint
#   }

#   template = "ubuntu-2004-cloudinit-template"
#   start_id = 4000

#   gateway = local.config.gateway


#   hosts = [
#     {
#       hostname    = "kcontrol-01"
#       mac_address = "FD:4F:87:84:FB:D3"
#       hastate     = "started"
#       node        = "curiosity"
#       ip          = "192.168.1.151"
#     },
#     {
#       hostname    = "kcontrol-02"
#       mac_address = "26:BB:E8:EF:D4:7B"
#       hastate     = "started"
#       node        = "curiosity"
#       ip          = "192.168.1.152"
#     },
#     {
#       hostname    = "kworker-01"
#       mac_address = "66:AA:2F:F6:36:C7"
#       hastate     = "started"
#       node        = "curiosity"
#       ip          = "192.168.1.153"

#     },
#     {
#       hostname    = "kworker-02"
#       mac_address = "3E:1A:84:A7:F6:FC"
#       hastate     = "started"
#       node        = "curiosity"
#       ip          = "192.168.1.154"
#     },
#     {
#       hostname    = "kworker-03"
#       mac_address = "FD:AD:5A:3D:38:32"
#       hastate     = "started"
#       node        = "curiosity"
#       ip          = "192.168.1.155"
#     }
#   ]

#   specs = {
#     bridge     = "vmbr0"
#     cores      = 2
#     min_memory = 4096
#     max_memory = 12288
#     size       = "20"
#     sockets    = 1
#     storage    = "vm_pool"
#   }

# }

