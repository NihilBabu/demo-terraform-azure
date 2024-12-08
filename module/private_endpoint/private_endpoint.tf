resource "azurerm_private_endpoint" "main" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group
  subnet_id           = var.subnet_id
  tags                = var.tags
  private_service_connection {
    name                              = var.service_connection
    #private_connection_resource_alias = var.resource_alias
    private_connection_resource_id = var.resource_id
    is_manual_connection              = true
    request_message                   = "PL"
  }
}
