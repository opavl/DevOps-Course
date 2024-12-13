resource_group_name             = "APav-HW(8)"
location                        = "West Europe"
virtual_network_name            = "hw10-Vnet"
vnet_address_space              = ["20.20.10.0/24"]
subnet_name                     = "hw10-subnet"
subnet_address_prefix           = "20.20.10.128/25"
availability_set_name           = "hw10-AvailabilitySet"
platform_fault_domain_count     = 2
platform_update_domain_count    = 5
load_balancer_name              = "hw10-LoadBalancer"
frontend_ip_name                = "hw10-FrontendIP"
backend_pool_name               = "hw10-BackendPool"
public_ip_name                  = "hw10-PublicIP"
health_probe_name               = "hw10-HealthProbe"
load_balancing_rule_name        = "hw10-LoadBalancingRule"
vm_count                        = 2
vm_size                         = "Standard_B1s"
vm_admin_username               = "adminuser"

vm_admin_password               = "PASSWORD"

client_id                       = "CLIENT-ID"
client_secret                   = "CLIENT-SECRET"
subscription_id                 = "SUBSC-ID"
tenant_id                       = "TENANT-ID"