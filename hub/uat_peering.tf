provider "azurerm" {
  subscription_id = var.peering_uat.subscription_id
  alias           = "uat"
  features {}
}

data "azurerm_virtual_network" "uat" {
  name                = var.peering_uat.vnet_name
  resource_group_name = var.peering_uat.resource_group
  provider            = azurerm.uat
}

resource "azurerm_virtual_network_peering" "peering_self_to_uat" {
  count                        = var.peering_uat.enabled ? 1 : 0
  name                         = "${module.vnet.name}-to-${var.peering_uat.vnet_name}"
  resource_group_name          = module.resource_group.name
  virtual_network_name         = module.vnet.name
  remote_virtual_network_id    = data.azurerm_virtual_network.uat.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
}

resource "azurerm_virtual_network_peering" "uat_self_to_self" {
  count                        = var.peering_uat.enabled ? 1 : 0
  name                         = "${var.peering_uat.resource_group}-to-${module.vnet.name}"
  resource_group_name          = data.azurerm_virtual_network.uat.resource_group_name
  virtual_network_name         = data.azurerm_virtual_network.uat.name
  remote_virtual_network_id    = module.vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  provider                     = azurerm.uat
}


resource "azurerm_private_dns_zone_virtual_network_link" "uat" {
  name                  = "uat.sharafdg.com-link-${module.vnet.name}"
  resource_group_name   = "csp-uks-u-sdgmapp-rg"
  private_dns_zone_name = "uat.sharafdg.com"
  virtual_network_id    = module.vnet.id
  provider              = azurerm.uat
}