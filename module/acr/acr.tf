resource "azurerm_container_registry" "acr" {
  name                = var.name
  resource_group_name = var.resource_group
  location            = var.location
  tags                = var.tags
  sku                 = "Standard"
  admin_enabled       = true
}
