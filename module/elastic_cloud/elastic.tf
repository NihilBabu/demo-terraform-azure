
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

resource "azurerm_private_endpoint" "main" {
  name                = var.endpoint_name
  location            = var.location
  resource_group_name = var.resource_group
  subnet_id           = var.subnet_id
  tags                = var.tags
  private_service_connection {
    name                              = var.service_connection
    private_connection_resource_alias = var.resource_alias
    is_manual_connection              = true
    request_message                   = "PL"
  }
}

resource "azurerm_private_dns_a_record" "main" {
  name                = "*"
  zone_name           = azurerm_private_dns_zone.main.name
  resource_group_name = var.resource_group
  ttl                 = 300
  records             = [azurerm_private_endpoint.main.private_service_connection[0].private_ip_address]
}
