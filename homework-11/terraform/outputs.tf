output "resource_group_name" {
  description = "Name of the resource group"
  value       = data.azurerm_resource_group.rg.name
}

output "virtual_network_name" {
  description = "Name of the virtual network"
  value       = data.azurerm_virtual_network.vnet.name
}

output "load_balancer_public_ip" {
  description = "Public IP of the load balancer"
  value       = azurerm_public_ip.pi10.ip_address
}

output "vm_public_ips" {
  description = "Public IP of the each VM balancer"
  value = [for i in range(var.vm_count) : azurerm_public_ip.pi10.id]
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

resource "null_resource" "ansible-crutch" {
  depends_on = [azurerm_public_ip.pi10]

  provisioner "local-exec" {
    command = <<EOT
      rm -f hosts.ini
      for i in $(seq 0 $(( ${length(azurerm_linux_virtual_machine.VM)} - 1 ))); do
        vm_name=$(terraform output -json vm_names | jq -r ".[$i]")
        private_ip=$(terraform output -json vm_private_ips | jq -r ".[$i]")
        printf "%s ansible_host=%s ansible_user=azureuser ansible_ssh_private_key_file=./private_key.pem\\n" "$vm_name" "$private_ip" >> ./ansible/hosts.ini
      done
    EOT
  }
}
 
