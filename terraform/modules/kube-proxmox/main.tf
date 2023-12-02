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

resource "proxmox_virtual_environment_vm" "kube_node" {
    
    count = length(var.hosts)

    vm_id = var.start_id + count.index
    name = var.hosts[count.index].hostname
    description = "kube node ${count.index} - Managed by terraform"
    started=true 

    //Hardcoded for now
    node_name = "curiosity"
    tags = [ "terraform", "kubernetes", "ubuntu" ]

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

        user_account {
            keys     = [trimspace(tls_private_key.ubuntu_vm_key.public_key_openssh)]
            password = random_password.ubuntu_vm_password.result
            username = "ubuntu"
        }

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

resource "tls_private_key" "ubuntu_vm_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

output "ubuntu_vm_password" {
  value     = random_password.ubuntu_vm_password.result
  sensitive = true
}

output "ubuntu_vm_private_key" {
  value     = tls_private_key.ubuntu_vm_key.private_key_pem
  sensitive = true
}

output "ubuntu_vm_public_key" {
  value = tls_private_key.ubuntu_vm_key.public_key_openssh
}
