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

resource "local_file" "private_key" {
  content         = tls_private_key.example.private_key_pem
  filename        = "private_key.pem"
  file_permission = "0600"
}

output "ssh_public_key" {
  value = azurerm_ssh_public_key.example.public_key
}

output "load_balancer_ip" {
  value = azurerm_public_ip.pi10.ip_address
}

output "load_balancer_nat_rules" {
  value = [for i in azurerm_lb_nat_rule.ssh_nat : i.frontend_port]
}

output "ansible_inventory" {
  value = <<EOT
[vms]
${join("\n", [for idx, vm_name in azurerm_linux_virtual_machine.VM[*].name : "${vm_name} ansible_host=${azurerm_public_ip.pi10.ip_address} ansible_port=${azurerm_lb_nat_rule.ssh_nat[idx].frontend_port} ansible_user=adminuser ansible_ssh_private_key_file=~/.ssh/private_key.pem"])}
EOT
}




