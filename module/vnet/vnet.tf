
resource "azurerm_virtual_network" "main" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group
  address_space       = var.address_space
  tags                = var.tags
}


# resource "azurerm_virtual_network_peering" "peering_self_to_remote" {
#   for_each                  = var.peering
#   name                      = "${var.name}-to-${each.key}"
#   resource_group_name       = var.resource_group
#   virtual_network_name      = azurerm_virtual_network.main.name
#   remote_virtual_network_id = each.value

#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = true
#   allow_gateway_transit        = false
# }
