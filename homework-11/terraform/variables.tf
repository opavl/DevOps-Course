variable "resource_group_name" {
  type        = string
}

variable "location" {
  type        = string
}

variable "virtual_network_name" {
  type        = string
}

variable "vnet_address_space" {
  type        = list(string)
}

variable "subnet_name" {
  type        = string
}

variable "subnet_address_prefix" {
  type        = string
}

variable "availability_set_name" {
  type        = string
}

variable "platform_fault_domain_count" {
  type        = number
}

variable "platform_update_domain_count" {
  type        = number
}

variable "load_balancer_name" {
  type        = string
}

variable "frontend_ip_name" {
  type        = string
}

variable "backend_pool_name" {
  type        = string
}

variable "public_ip_name" {
  type        = string
}

variable "health_probe_name" {
  type        = string
}

variable "load_balancing_rule_name" {
  type        = string
}

variable "vm_count" {
  type        = number
}

variable "vm_size" {
  type        = string
}

variable "vm_admin_username" {
  type        = string
  sensitive   = true
}

variable "client_id" {
  description = "Azure AD Application (Client) ID"
  type        = string
  sensitive   = true
}

variable "client_secret" {
  description = "Azure AD Application Secret"
  type        = string
  sensitive   = true
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
  sensitive   = true
}

variable "allowed_source_prefixes" {
  type        = list(string)
}
