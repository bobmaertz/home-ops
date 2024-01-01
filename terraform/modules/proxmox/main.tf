terraform {
    required_providers {
        proxmox = {
            source = "bpg/proxmox"
            version = "0.42.1"
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


resource "proxmox_virtual_environment_vm" "compute_node" {
    
    count = length(var.hosts)

    vm_id = var.start_id + count.index
    name = var.hosts[count.index].hostname
    description = "node ${count.index} - Managed by terraform"
    started=true 

    //Hardcoded for now
    node_name = "curiosity"
    tags = [ "terraform", "ubuntu"]

    agent {
        enabled = true
    }

    cpu {
        cores  = var.specs.cores 
        sockets = var.specs.sockets
    }

    memory {
      dedicated = var.specs.max_memory
      floating = var.specs.min_memory
    }

    operating_system {
      type = "l26"
    }

    disk {
        datastore_id = "vm_pool"
        file_id      = proxmox_virtual_environment_file.ubuntu_cloud_image.id
        interface    = "scsi0"
    }
 
    network_device {
        model = "virtio"
        bridge  = var.specs.bridge
    }

    initialization {
        ip_config {
            ipv4 {
                address = "dhcp"
            }
        }

        # user_account {
        #     keys     = [trimspace(tls_private_key.ubuntu_vm_key.public_key_openssh)]
        #     password = random_password.ubuntu_vm_password.result
        #     username = "ubuntu"
        # }

        user_data_file_id = proxmox_virtual_environment_file.cloud_config.id
    }
}

resource "proxmox_virtual_environment_file" "cloud_config" {
  content_type = "snippets"
  datastore_id = var.datastoreId
  node_name    = "curiosity"

  source_file {
    path = "cloud_init/data.yml"
  }
}

resource "proxmox_virtual_environment_file" "ubuntu_cloud_image" {
  content_type = "iso"
  datastore_id = var.datastoreId
  node_name    = "curiosity"

  source_file {
    path = "http://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img"
  }
}

resource "random_password" "ubuntu_vm_password" {
  length           = 16
  override_special = "_%@"
  special          = true
}

# resource "tls_private_key" "ubuntu_vm_key" {
#   algorithm = "RSA"
#   rsa_bits  = 2048
# }

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

data "proxmox_virtual_environment_dns" "curiosity_dns_configuration" {
  node_name = "curiosity"
}

output "proxmox_user_password" {
  value     = random_password.user_password.result
  sensitive = true
}

# output "vm_private_key" {
#   value     = tls_private_key.ubuntu_vm_key.private_key_pem
#   sensitive = true
# }

# output "vm_public_key" {
#   value = tls_private_key.ubuntu_vm_key.public_key_openssh
# }
