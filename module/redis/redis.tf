resource "azurerm_redis_cache" "main" {
  name                          = var.name
  location                      = var.location
  tags                          = var.tags
  resource_group_name           = var.resource_group
  capacity                      = var.capacity
  family                        = var.family
  sku_name                      = var.sku_name
  enable_non_ssl_port           = false
  minimum_tls_version           = "1.2"
  public_network_access_enabled = false

  redis_configuration {
  }
}


resource "azurerm_private_endpoint" "main" {
  name                = "${var.name}-pep"
  location            = var.location
  resource_group_name = var.resource_group
  subnet_id           = var.subnet

  private_dns_zone_group {
    name                 = var.name
    private_dns_zone_ids = [var.private_dns_id]
  }

  private_service_connection {
    name                           = "${var.name}-psc"
    private_connection_resource_id = azurerm_redis_cache.main.id
    subresource_names              = ["redisCache"]
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
