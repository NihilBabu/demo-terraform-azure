resource "azurerm_private_link_service" "main" {
  name                = var.name
  resource_group_name = var.resource_group
  location            = var.location
  tags                = var.tags

  load_balancer_frontend_ip_configuration_ids = var.frontend_ip_configuration_ids

  nat_ip_configuration {
    name                       = "primary"
    private_ip_address_version = "IPv4"
    subnet_id                  = var.lb_subnet_id
    primary                    = true
  }
}
