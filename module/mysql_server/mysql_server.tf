resource "random_password" "password" {
  length           = 16
  special          = false
  # override_special = "_%@[}"
  number           = true
}

resource "azurerm_mysql_server" "main" {
  name                              = var.name
  location                          = var.location
  resource_group_name               = var.resource_group
  tags                              = var.tags
  administrator_login               = var.admin_user
  administrator_login_password      = random_password.password.result
  sku_name                          = var.sku
  storage_mb                        = var.storage_mb
  version                           = var.mysql_version
  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = true
  infrastructure_encryption_enabled = true
  public_network_access_enabled     = false
  ssl_enforcement_enabled           = var.ssl_enabled
  ssl_minimal_tls_version_enforced  = var.ssl_version
}

resource "azurerm_private_endpoint" "main" {
  name                = "${var.name}-pep"
  location            = var.location
  resource_group_name = var.resource_group
  subnet_id           = var.subnet_id

  private_dns_zone_group {
    name                 = var.name
    private_dns_zone_ids = [var.private_dns_id]
  }

  private_service_connection {
    name                           = "${var.name}-psc"
    private_connection_resource_id = azurerm_mysql_server.main.id
    subresource_names              = ["mysqlServer"]
    is_manual_connection           = false
  }
}

resource "azurerm_private_dns_a_record" "main" {
  name                = var.name
  zone_name           = var.private_dns_name
  resource_group_name = var.resource_group
  ttl                 = 3600
  records             = [azurerm_private_endpoint.main.private_service_connection.0.private_ip_address]
}

resource "azurerm_key_vault_secret" "admin_username" {
  name         = "${var.name}-admin-username"
  value        = "${var.admin_user}@${var.name}"
  key_vault_id = var.key_vault
}

resource "azurerm_key_vault_secret" "admin_password" {
  name         = "${var.name}-admin-password"
  value        = random_password.password.result
  key_vault_id = var.key_vault
}
