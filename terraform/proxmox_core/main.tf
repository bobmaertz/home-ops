terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.51.1"
    }
  }
}
provider "proxmox" {
  username = var.proxmox_user_name
  password = var.proxmox_user_password
  endpoint = var.proxmox_endpoint
  insecure = true
  ssh {
    agent = false
  }
}

resource "proxmox_virtual_environment_dns" "curiosity_dns_configuration" {
  domain    = data.proxmox_virtual_environment_dns.curiosity_dns_configuration.domain
  node_name = data.proxmox_virtual_environment_dns.curiosity_dns_configuration.node_name

  servers = var.dns_nameservers
}

# resource "proxmox_virtual_environment_cluster_firewall_security_group" "ping_ssh" {
#   name    = "Firewall SSH and PING"
#   comment = "Firewall SSH and PING"

#   rule {
#     comment = "Ping"
#     type    = "in"
#     action  = "ACCEPT"
#     proto   = "icmp"
#   }

#   rule {
#     comment = "SSH"
#     type    = "in"
#     action  = "ACCEPT"
#     macro   = "SSH"
#   }

# }

# resource "proxmox_virtual_environment_cluster_firewall_security_group" "node_exp" {
#   name    = "promtail-node-exp"
#   comment = "Promtail and node exporter"

#   # rule {
#   #   type    = "in"
#   #   action  = "ACCEPT"
#   #   comment = "Promtail"
#   #   proto   = "tcp"
#   #   dport   = "9080"
#   # }

#   rule {
#     type    = "in"
#     action  = "ACCEPT"
#     comment = "Prometheus node exporter"
#     proto   = "tcp"
#     dport   = "9100"
#   }

# }

resource "proxmox_virtual_environment_hosts" "curiosity_host_entries" {
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

data "proxmox_virtual_environment_dns" "curiosity_dns_configuration" {
  node_name = "curiosity"
}

module "services" {
  source = "./modules/compute_node"

  datastore_id = "synology-nas-backup"

  proxmox_user_name     = var.proxmox_user_name
  proxmox_user_password = var.proxmox_user_password
  proxmox_endpoint      = var.proxmox_endpoint


  template = var.template_name
  start_id = 5000

  gateway   = var.gateway
  node_name = "curiosity"
  vms = [
    {
      name = "home-services"
    }
  ]

  specs = {
    bridge       = "vmbr0"
    cores        = 2
    min_memory   = 2048
    max_memory   = 12288
    disk_size    = "24"
    sockets      = 1
    datastore_id = "vm_pool"
  }

}


module "k3s" {
  source = "./modules/compute_node"

  datastore_id = "synology-nas-backup"

  proxmox_user_name     = var.proxmox_user_name
  proxmox_user_password = var.proxmox_user_password
  proxmox_endpoint      = var.proxmox_endpoint


  template = var.template_name
  start_id = 6000

  gateway   = var.gateway
  node_name = "curiosity"
  vms = [
    {
      name = "control-0"
    },
    {
      name = "control-1"
    },
    {
      name = "worker-0"
    },
    {
      name = "worker-1"
    },
    {
      name = "worker-2"
    }

  ]

  specs = {
    bridge       = "vmbr0"
    cores        = 2
    min_memory   = 4096
    max_memory   = 12288
    disk_size    = "24"
    sockets      = 1
    datastore_id = "vm_pool"
  }

}



