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
    agent    = false
  }
}


resource "proxmox_virtual_environment_vm" "compute_vm" {

  count = length(var.vms)

  vm_id       = var.start_id + count.index
  name        = var.vms[count.index].name
  description = "node ${count.index} - Managed by terraform"
  started     = true

  node_name = "curiosity"
  tags      = ["terraform", "ubuntu"] //Add tag based on service/..

  agent {
    enabled = true
  }

  cpu {
    cores   = var.specs.cores
    sockets = var.specs.sockets
  }

  memory {
    dedicated = var.specs.max_memory
    floating  = var.specs.min_memory
  }

  operating_system {
    type = "l26"
  }

  disk {
    datastore_id = var.specs.datastore_id
    file_id      = proxmox_virtual_environment_download_file.release_20231228_focal_server_cloudimg_amd64_iso_img.id
    interface    = "virtio0" 
    size         = var.specs.disk_size
  }

  network_device {
    model  = "virtio"
    bridge = var.specs.bridge
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.cloud_config.id
  }
}

resource "proxmox_virtual_environment_file" "cloud_config" {
  content_type = "snippets"
  datastore_id = var.datastore_id
  node_name    = var.node_name

  source_file {
    path = "cloud_init/data.yml"
  }
}



resource "proxmox_virtual_environment_download_file" "release_20231228_focal_server_cloudimg_amd64_iso_img" {
  content_type       = "iso"
  datastore_id       = var.datastore_id
  file_name          = "focal-server-cloudimg-amd64.img"
  node_name          = var.node_name
  url                = "http://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img"
  checksum           = "edf43eb9f4e5ededbb3606c719c98b0e14c956278da42567e907a17d8bccb571"
  checksum_algorithm = "sha256"
}

