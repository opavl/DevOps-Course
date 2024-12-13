output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.rg.name
}

output "virtual_network_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.vnet.name
}

output "load_balancer_public_ip" {
  description = "Public IP of the load balancer"
  value       = azurerm_public_ip.pi10.ip_address
}

output "vm_private_ips" {
  description = "Private IPs of the virtual machines"
  value       = azurerm_network_interface.nic10[*].private_ip_address
}

output "vm_names" {
  description = "Names of the virtual machines"
  value       = azurerm_linux_virtual_machine.VM[*].name
}