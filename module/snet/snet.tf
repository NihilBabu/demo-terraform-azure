resource "azurerm_subnet" "main" {
  name                                           = var.name
  resource_group_name                            = var.resource_group
  virtual_network_name                           = var.vnet_name
  address_prefixes                               = var.address_prefixes
  enforce_private_link_endpoint_network_policies = true
  enforce_private_link_service_network_policies  = true
  service_endpoints                              = var.service_endpoints
}
