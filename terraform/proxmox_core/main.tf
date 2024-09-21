
module "k3s" {
  source = "./modules/compute_node"

  datastore_id = "vm_pool"

  proxmox_user_name     = var.proxmox_user_name
  proxmox_user_password = var.proxmox_user_password
  proxmox_endpoint      = var.proxmox_endpoint
  ssh_pub_key_file      = var.ssh_public_key

  start_id = 7000

  gateway   = var.gateway
  node_name = "curiosity"
  vms = [
    {
      name         = "control-0"
      bridge       = "vmbr0"
      cores        = 2
      min_memory   = 4096
      disk_size    = "24"
      sockets      = 1
      datastore_id = "vm_pool"
      ip_address   = "192.168.3.70/24"
    },
    {
      name         = "control-1"
      bridge       = "vmbr0"
      cores        = 2
      min_memory   = 4096
      disk_size    = "24"
      sockets      = 1
      datastore_id = "vm_pool"
      ip_address   = "192.168.3.71/24"
    },
    {
      name         = "worker-0"
      bridge       = "vmbr0"
      cores        = 2
      min_memory   = 4096
      disk_size    = "24"
      sockets      = 1
      datastore_id = "vm_pool"
      ip_address   = "192.168.3.72/24"
    },
    {
      name         = "worker-1"
      bridge       = "vmbr0"
      cores        = 2
      min_memory   = 4096
      disk_size    = "24"
      sockets      = 1
      datastore_id = "vm_pool"
      ip_address   = "192.168.3.73/24"
    },
    {
      name         = "worker-2"
      bridge       = "vmbr0"
      cores        = 2
      min_memory   = 4096
      disk_size    = "24"
      sockets      = 1
      datastore_id = "vm_pool"
      ip_address   = "192.168.3.74/24"
    }
  ]
}



