terraform {
}


//TODO: Remove the local and use environment variables instead
// Most of this can be done with the terraform.tfvars file
locals {
  config  = yamldecode(file("${path.module}/config.yaml"))
}

output "out" {
    value = local.config
}

module "core" {
  source = "./modules/core"
  proxmox = {
    username        = local.config.proxmox.user
    password        = local.config.proxmox.password
    endpoint        = local.config.proxmox.endpoint
  }
}

module "k3s" {
  source = "./modules/kubernetes"

  datastoreId = "synology-nas-backup"

  proxmox = {
    username        = local.config.proxmox.user
    password        = local.config.proxmox.password
    endpoint        = local.config.proxmox.endpoint
  }

  pubkey       = local.config.publickey
  pvtkey       = local.config.privatekey

  template = "ubuntu-2004-cloudinit-template"
  start_id = 4000

  gateway = local.config.gateway


  hosts = [
    {
      hostname    = "kcontrol-01"
      mac_address = "FD:4F:87:84:FB:D3"
      hastate     = "started"
      node        = "curiosity"
      ip        = "192.168.1.151"
    },
    {
      hostname    = "kcontrol-02"
      mac_address = "26:BB:E8:EF:D4:7B"
      hastate     = "started"
      node        = "curiosity"
      ip        = "192.168.1.152"
    },
    {
      hostname    = "kworker-01"
      mac_address = "66:AA:2F:F6:36:C7"
      hastate     = "started"
      node        = "curiosity"
      ip        = "192.168.1.153"

    },
    {
      hostname    = "kworker-02"
      mac_address = "3E:1A:84:A7:F6:FC"
      hastate     = "started"
      node        = "curiosity"
      ip        = "192.168.1.154"
    },
    {
      hostname    = "kworker-03"
      mac_address = "FD:AD:5A:3D:38:32"
      hastate     = "started"
      node        = "curiosity"
      ip        = "192.168.1.155"
    }
  ]

  specs = {
    bridge  = "vmbr0"
    cores   = 2
    min_memory = 4096
    max_memory = 12288
    size    = "20"
    sockets = 1
    storage = "vm_pool"
  }

}

