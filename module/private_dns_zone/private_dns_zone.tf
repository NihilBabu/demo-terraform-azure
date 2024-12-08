
resource "azurerm_private_dns_zone" "main" {
  name                = var.name
  resource_group_name = var.resource_group
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "main" {
  name                  = "${var.name}-link-${var.vnet_name}"
  resource_group_name   = var.resource_group
  private_dns_zone_name = azurerm_private_dns_zone.main.name
  virtual_network_id    = var.vnet_id
}
