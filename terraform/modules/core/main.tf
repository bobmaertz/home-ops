terraform {
    required_providers {
        proxmox = {
            source = "bpg/proxmox"
            version = "0.31.0"
        }
    }
}

provider "proxmox" {
    username = "${var.proxmox.username}@pam"
    password = var.proxmox.password
    endpoint = var.proxmox.endpoint
    insecure = true
    ssh {
        agent = true 
        username = var.proxmox.username
    }
}

resource "proxmox_virtual_environment_user" "operations_automation" {
  comment  = "Managed by Terraform"
  password = random_password.user_password.result
  user_id  = "terraform_provider@pve"
}


resource "random_password" "user_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "proxmox_virtual_environment_role" "terraform_provider" {
  role_id = "terraform_provider"

  privileges = [
    "Datastore.Audit",
    "VM.Config.CDROM",
    "Sys.Console", 
    "Pool.Allocate", 
    "VM.Config.Network", 
    "VM.Config.CPU", 
    "VM.PowerMgmt", 
    "VM.Migrate", 
    "Datastore.AllocateSpace", 
    "Sys.Audit", 
    "VM.Allocate", 
    "VM.Monitor", 
    "VM.Config.HWType", 
    "VM.Config.Memory", 
    "VM.Config.Options", 
    "VM.Config.Disk", 
    "VM.Clone", 
    "Sys.Modify", 
    "VM.Audit", 
    "VM.Config.Cloudinit",
  ]
}

resource "proxmox_virtual_environment_dns" "curiousity_dns_configuration" {
  domain    = data.proxmox_virtual_environment_dns.curiosity_dns_configuration.domain
  node_name = data.proxmox_virtual_environment_dns.curiosity_dns_configuration.node_name

  servers = [
    "192.168.1.185",
    "1.1.1.1", 
    "8.8.8.8" 
  ]
}

data "proxmox_virtual_environment_dns" "curiosity_dns_configuration" {
  node_name = "curiosity"
}

resource "proxmox_virtual_environment_hosts" "first_node_host_entries" {
  node_name = "curiosity"
  entry {
    address = "127.0.0.1"

    hostnames = [
      "localhost",
      "localhost.localdomain",
    ]
  }
  entry {
    address = "192.168.1.110"

    hostnames = [
    "curiosity.home",  
    "curiosity" 
    ]
  }
}


# using custom network interface name
//resource "proxmox_virtual_environment_network_linux_vlan" "vlan60" {
//  node_name = "curiosity"
//  name      = "vlan_lab"
//
//  interface = "enp7s0"
//  vlan      = 60 
//  comment   = "VLAN 60"
//}
//
//resource "proxmox_virtual_environment_network_linux_bridge" "vmbr1" {
//  depends_on = [
//    proxmox_virtual_environment_network_linux_vlan.vlan60
//  ]
//
//  node_name = "curiosity"
//  name      = "vmbr1"
//
//  address = "192.168.1.110/24"
//  gateway = "192.168.1.1" 
//
//  mtu = 1500
//  comment = "Default bridge - Managed by Terraform"
//
//  vlan_aware = true
//
//  ports = [
//    "enp7s0"
//  ]
//}
