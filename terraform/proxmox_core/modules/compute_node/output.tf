output "ip_addresses" {
  description = "List of private IP addresses assigned to the compute instances"
  value = [
    for ip in proxmox_virtual_environment_vm.compute_vm : ip.initialization.*.ip_config
    ]
}
