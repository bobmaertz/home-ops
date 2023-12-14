variable "proxmox" {
  type = object({
    username = string,
    password = string,
    endpoint = string,
  })
}
