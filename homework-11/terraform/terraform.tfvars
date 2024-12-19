resource_group_name             = "Jenkins-slaves-Homeworks"
location                        = "Central US"
virtual_network_name            = "Jenkins-slaves-vnet"
vnet_address_space              = ["10.0.11.0/24"]
subnet_name                     = "jenk-subnet2"
subnet_address_prefix           = "10.0.11.0/25"
availability_set_name           = "Jenkins-AS"
platform_fault_domain_count     = 2
platform_update_domain_count    = 5
load_balancer_name              = "Jenkins-LoadBalancer"
frontend_ip_name                = "Jenkins-FrontendIP"
backend_pool_name               = "Jenkins-BackendPool"
public_ip_name                  = "Jenkins-PublicIP"
health_probe_name               = "Jenkins-HealthProbe"
load_balancing_rule_name        = "Jenkins-LoadBalancingRule"
vm_count                        = 2
vm_size                         = "Standard_B1s"
vm_admin_username               = "adminuser"

allowed_source_prefixes         =["46.46.105.0/24", "10.0.64.0/19"]
