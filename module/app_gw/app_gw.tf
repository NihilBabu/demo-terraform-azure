resource "azurerm_public_ip" "main" {
  count               = var.public_listener ? 1 : 0
  name                = var.public_ip_name
  resource_group_name = var.resource_group
  location            = var.location
  allocation_method   = "Static"
  tags                = var.tags
  sku                 = "Standard"
  availability_zone   = "No-Zone"
}


locals {
  backend_address_pool_suffix      = "-beap"
  frontend_port_suffix             = "-feport"
  frontend_ip_configuration_suffix = "-feip"
  http_setting_suffix              = "-be-htst"
  listener_suffix                  = "-httplstn"
  request_routing_rule_suffix      = "-rqrt"
  redirect_configuration_suffix    = "-rdrcfg"
  health_prob_suffix               = "-hp"

  frontend_ip = {
    private_name = "private${local.frontend_ip_configuration_suffix}"
    public_name  = "public${local.frontend_ip_configuration_suffix}"
  }

}

resource "azurerm_user_assigned_identity" "base" {
  resource_group_name = var.resource_group
  location            = var.location
  name                = "mi-${var.name}"
  tags                = var.tags
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_application_gateway" "main" {
  name                = var.name
  resource_group_name = var.resource_group
  location            = var.location
  tags                = var.tags

  sku {
    name     = var.sku_name
    tier     = var.tier
    capacity = var.capacity
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.base.id]
  }

  gateway_ip_configuration {
    name      = "${var.name}-gw-ip-config"
    subnet_id = var.subnet_id
  }

  dynamic "frontend_ip_configuration" {
    for_each = var.public_listener ? [0] : []
    content {
      name                 = local.frontend_ip.public_name
      public_ip_address_id = azurerm_public_ip.main[0].id
    }
  }

  dynamic "frontend_ip_configuration" {
    for_each = var.private_listener.enabled ? [0] : []
    content {
      name                          = local.frontend_ip.private_name
      subnet_id                     = var.subnet_id
      private_ip_address_allocation = var.private_listener.address_allocation
      private_ip_address            = var.private_listener.ip_address
    }
  }


  dynamic "ssl_certificate" {
    for_each = var.ssl_certificate
    content {
      name                = ssl_certificate.key
      key_vault_secret_id = ssl_certificate.value.key_vault_secret_id
    }
  }

  dynamic "frontend_port" {
    for_each = var.frontend_port

    content {
      name = "${frontend_port.key}${local.frontend_port_suffix}"
      port = frontend_port.value
    }
  }


  dynamic "backend_address_pool" {
    for_each = var.backend_address_pool

    content {
      name         = "${backend_address_pool.key}${local.backend_address_pool_suffix}"
      ip_addresses = backend_address_pool.value
    }
  }


  dynamic "probe" {
    for_each = var.health_prob
    content {
      name                                      = "${probe.key}${local.health_prob_suffix}"
      protocol                                  = probe.value.protocol
      interval                                  = 5
      path                                      = probe.value.path
      timeout                                   = 5
      unhealthy_threshold                       = 5
      pick_host_name_from_backend_http_settings = true
      match {
        body        = ""
        status_code = ["200-500"]
      }
    }
  }


  dynamic "backend_http_settings" {
    for_each = var.http_settings
    content {
      name                                = "${backend_http_settings.key}${local.http_setting_suffix}"
      cookie_based_affinity               = "Disabled"
      port                                = backend_http_settings.value.port
      protocol                            = backend_http_settings.value.protocol
      request_timeout                     = backend_http_settings.value.request_timeout
      probe_name                          = "${backend_http_settings.value.probe_name}${local.health_prob_suffix}"
      host_name                           = backend_http_settings.value.host_name
      pick_host_name_from_backend_address = backend_http_settings.value.host_name != "" ? false : true
    }
  }

  dynamic "http_listener" {
    for_each = var.https_listener
    content {
      name                           = "${http_listener.key}${local.listener_suffix}"
      frontend_ip_configuration_name = "${http_listener.value.frontend_ip_configuration_name}${local.frontend_ip_configuration_suffix}"
      frontend_port_name             = "${http_listener.value.frontend_port_name}${local.frontend_port_suffix}"
      protocol                       = http_listener.value.protocol
      host_names                     = http_listener.value.host_names
      ssl_certificate_name           = http_listener.value.cert_name
    }
  }

  dynamic "http_listener" {
    for_each = var.http_listener
    content {
      name                           = "${http_listener.key}${local.listener_suffix}"
      frontend_ip_configuration_name = "${http_listener.value.frontend_ip_configuration_name}${local.frontend_ip_configuration_suffix}"
      frontend_port_name             = "${http_listener.value.frontend_port_name}${local.frontend_port_suffix}"
      protocol                       = http_listener.value.protocol
      host_names                     = http_listener.value.host_names
    }
  }

  dynamic "redirect_configuration" {
    for_each = var.redirect_configuration
    content {
      name                 = "${redirect_configuration.key}${local.redirect_configuration_suffix}"
      redirect_type        = redirect_configuration.value.redirect_type
      target_listener_name = "${redirect_configuration.value.target_listener_name}${local.listener_suffix}"
      include_path         = redirect_configuration.value.include_path
      include_query_string = redirect_configuration.value.include_query_string
    }
  }

  dynamic "request_routing_rule" {
    for_each = var.routing_rule
    content {
      name                       = "${request_routing_rule.key}${local.request_routing_rule_suffix}"
      rule_type                  = "Basic"
      http_listener_name         = "${request_routing_rule.value.http_listener_name}${local.listener_suffix}"
      backend_address_pool_name  = "${request_routing_rule.value.backend_address_pool_name}${local.backend_address_pool_suffix}"
      backend_http_settings_name = "${request_routing_rule.value.backend_http_settings_name}${local.http_setting_suffix}"
      priority                   = request_routing_rule.value.priority
    }
  }

  dynamic "request_routing_rule" {
    for_each = var.redirect_routing_rule
    content {
      name                        = "${request_routing_rule.key}${local.request_routing_rule_suffix}"
      rule_type                   = "Basic"
      http_listener_name          = "${request_routing_rule.value.http_listener_name}${local.listener_suffix}"
      redirect_configuration_name = "${request_routing_rule.value.redirect_configuration_name}${local.redirect_configuration_suffix}"
      priority                    = request_routing_rule.value.priority
    }
  }


  lifecycle {
    ignore_changes = [
      tags,
    ]
  }

}
