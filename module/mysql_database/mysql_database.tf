

resource "azurerm_mysql_database" "main" {
  count               = length(var.database)
  name                = var.database[count.index]
  resource_group_name = var.resource_group
  server_name         = var.server_name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}
