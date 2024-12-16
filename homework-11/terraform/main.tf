provider "azurerm" {
  features {}

  client_id       = var.client_id
  client_secret   = var.client_secret
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

# Resource Group
## referencing as 'data' instead of 'resource' to avod deletion 
data "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Virtual Network
data "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Subnet
data "azurerm_subnet" "subnt2" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_address_prefix]
}

# Security group creation
resource "azurerm_network_security_group" "nsg" {
  name                = "hw11-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  #web 
  security_rule {
    name                       = "WEB"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  #ssh 
  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefixes    = var.allowed_source_prefixes
    destination_address_prefix = "*"
  }
}

# Асоціація підмережі 1 з групою безпеки
resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association1" {
  subnet_id                 = azurerm_subnet.subnt2.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}


# Availability Set
resource "azurerm_availability_set" "as10" {
  name                = var.availability_set_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  platform_fault_domain_count  = var.platform_fault_domain_count
  platform_update_domain_count = var.platform_update_domain_count
  managed                      = true
}

# Public IP for Load Balancer
resource "azurerm_public_ip" "pi10" {
  name                = var.public_ip_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Load Balancer
resource "azurerm_lb" "lb10" {
  name                = var.load_balancer_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = var.frontend_ip_name
    public_ip_address_id = azurerm_public_ip.pi10.id
  }
}

# Backend Address Pool
resource "azurerm_lb_backend_address_pool" "bap10" {
  loadbalancer_id = azurerm_lb.lb10.id
  name            = var.backend_pool_name
}

# Health Probe
resource "azurerm_lb_probe" "hp10" {
  loadbalancer_id = azurerm_lb.lb10.id
  name            = var.health_probe_name
  port            = 80
}

# Load Balancing Rule
resource "azurerm_lb_rule" "hr10" {
  loadbalancer_id                = azurerm_lb.lb10.id
  name                           = var.load_balancing_rule_name
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = var.frontend_ip_name
  probe_id                       = azurerm_lb_probe.hp10.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.bap10.id]
}

# Network Interface
resource "azurerm_network_interface" "nic10" {
  count               = var.vm_count
  name                = "nic-${count.index + 1}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnt2.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pi10[count.index].id

  }
}

# Network Interface Backend Address Pool Association
resource "azurerm_network_interface_backend_address_pool_association" "nic-bapa10" {
  count                   = var.vm_count
  network_interface_id    = azurerm_network_interface.nic10[count.index].id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.bap10.id
}

# Linux Virtual Machines
resource "azurerm_linux_virtual_machine" "VM" {
  count               = var.vm_count
  name                = "hw-11-vm-${count.index + 1}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = var.vm_size
  admin_username      = var.vm_admin_username
  availability_set_id = azurerm_availability_set.as10.id
  network_interface_ids = [
    azurerm_network_interface.nic10[count.index].id
  ]

    # SSH key instead password 
  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = tls_private_key.example.public_key_openssh
  }
  disable_password_authentication = true


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = {
    environment = "jenkins"
  }
}

# SSH generation
resource "azurerm_ssh_public_key" "example" {
  name                = "hw11-ssh-key-${random_string.example.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  public_key          = tls_private_key.example.public_key_openssh
}

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

#random strings for SSH key (optional)
resource "random_string" "example" {
  length  = 8
  special = false
  upper   = false
}