terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc3"
    }
  }
}

provider "proxmox" {
  pm_user     = var.proxmox_user_name
  pm_password = var.proxmox_user_password
  # pm_api_url  = var.proxmox_endpoint
  pm_api_url  = "https://192.168.3.110:8006/api2/json"
  pm_parallel = 2
}


resource "proxmox_vm_qemu" "compute_vm" {
  name = var.vms[count.index].name
  desc = "A test for using terraform and cloudinit"

  count = length(var.vms)

  vmid = var.start_id + count.index
  # Node name has to be the same name as within the cluster
  # this might not include the FQDN
  target_node = "curiosity"

  # The template name to clone this vm from
  clone = var.template

  # Activate QEMU agent for this VM
  agent = 1

  os_type = "cloud-init"
  cores   = 2
  sockets = 1
  vcpus   = 0
  cpu     = "host"
  memory  = 2048
  scsihw  = "lsi"

  # Setup the disk
  disks {
    ide {
      ide3 {
        cloudinit {
          storage = "vm_pool"
        }
      }
    }
    virtio {
      virtio0 {
        disk {
          size    = 32
          cache   = "writeback"
          storage = "vm_pool"
          #storage_type    = "zfs"
          iothread = true
          discard  = true
        }
      }
    }
  }

  # Setup the network interface and assign a vlan tag: 256
  network {
    model  = "virtio"
    bridge = "vmbr0"
    tag    = 256
  }

  # Setup the ip address using cloud-init.
  boot = "order=virtio0"
  # Keep in mind to use the CIDR notation for the ip.
  #ipconfig0 = "ip=192.168.3.1/24,gw=192.168.10.1"

}
