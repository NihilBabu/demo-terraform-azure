
resource "azurerm_route_table" "main" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group
  tags                = var.tags
}

resource "azurerm_route" "main" {
  for_each               = var.routes
  name                   = each.key
  resource_group_name    = var.resource_group
  route_table_name       = azurerm_route_table.main.name
  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  next_hop_in_ip_address = each.value.destination
}

resource "azurerm_subnet_route_table_association" "main" {
  subnet_id      = "${var.subnet_id_prefix}${var.subnet}"
  route_table_id = azurerm_route_table.main.id
}
