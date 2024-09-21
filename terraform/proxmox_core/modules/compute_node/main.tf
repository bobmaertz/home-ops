terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.64.0"
    }
  }
}

provider "proxmox" {
  username = var.proxmox_user_name
  password = var.proxmox_user_password
  endpoint = var.proxmox_endpoint
  insecure = true
}


resource "proxmox_virtual_environment_vm" "compute_vm" {
  count = length(var.vms)

  vm_id       = var.start_id + count.index
  name        = var.vms[count.index].name
  description = "node ${count.index} - Managed by terraform"
  started     = true

  node_name = "curiosity"
  tags      = ["terraform", "ubuntu"] //Add tag based on service/..


  //Having a hard time cloning correctly, cant resize the disk property 
  //TODO: Set this as optional and pass in the vm_id 
  clone {
    vm_id   = 8002
    full    = true
    retries = 3
  }

  agent {
    enabled = true
  }

  cpu {
    cores   = var.vms[count.index].cores
    sockets = var.vms[count.index].sockets
  }

  memory {
    dedicated = var.vms[count.index].min_memory
  }


  //TODO: More consistent parameterization 
  // Only use if not cloning, cloning is weird and i cant seem to get the resize to work correctly 
  // disk {
  //   datastore_id = var.vms[count.index].datastore_id
  //   iothread     = true
  //   interface    = "virtio0"
  //   file_format  = "raw"
  //   size         = var.vms[count.index].disk_size
  // }

  network_device {
    model  = "virtio"
    bridge = var.vms[count.index].bridge
  }

  initialization {
    user_account {
      username = "ubuntu"
      keys     = [trimspace(data.local_file.ssh_public_key.content)]
    }
    ip_config {
      ipv4 {
        address = var.vms[count.index].ip_address
        gateway = var.gateway
      }
    }
  }
}

data "local_file" "ssh_public_key" {
  filename = var.ssh_pub_key_file
}
