terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.51.1"
    }
  }
}
provider "proxmox" {
  username = "${var.proxmox_user_name}@pam"
  password = var.proxmox_user_password
  endpoint = var.proxmox_endpoint
  insecure = true # because self-signed TLS certificate is in use
  ssh {
    agent    = true
    username = var.proxmox_user_name
  }
}


resource "random_password" "operations_automation_user_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "proxmox_virtual_environment_user" "operations_automation" {
  comment  = "Managed by Terraform"
  password = random_password.operations_automation_user_password.result
  user_id  = "operations_automation@pve"
  acl {
    path = "/"
    propagate = true
    role_id   = proxmox_virtual_environment_role.terraform_provider_role.role_id
  }
}

resource "proxmox_virtual_environment_role" "terraform_provider_role" {
  role_id = "terraform_provider_role"

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

