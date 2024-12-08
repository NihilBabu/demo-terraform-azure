resource "azurerm_public_ip" "main" {
  name                = var.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group
  tags                = var.tags
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall_policy" "main" {
  tags                = var.tags
  name                = "${var.name}-policy"
  resource_group_name = var.resource_group
  location            = var.location
  sku                 = var.sku_tier
  dns {
    proxy_enabled = true
  }
}

resource "azurerm_firewall" "main" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group
  sku_tier            = var.sku_tier
  sku_name            = "AZFW_VNet"
  tags                = var.tags
  firewall_policy_id  = azurerm_firewall_policy.main.id
  ip_configuration {
    name                 = "${var.name}-ip"
    subnet_id            = var.subnet_id
    public_ip_address_id = azurerm_public_ip.main.id
  }
  depends_on = [ azurerm_firewall_policy.main ]
}


# resource "azurerm_monitor_diagnostic_setting" "main" {
#   name                           = "${var.name}-diag"
#   target_resource_id             = azurerm_firewall.main.id
#   log_analytics_destination_type = "AzureDiagnostics"
#   log_analytics_workspace_id     = var.workspace_id

#   # log {
#   #   category = "AzureFirewallApplicationRule"
#   #   enabled  = true
#   #   retention_policy {
#   #     enabled = true
#   #     days    = 5
#   #   }
#   # }

#   # log {
#   #   category = "AzureFirewallNetworkRule"
#   #   enabled  = true
#   #   retention_policy {
#   #     enabled = true
#   #     days    = 5
#   #   }
#   # }
#   # log {
#   #   category = "AzureFirewallDnsProxy"
#   #   enabled  = true
#   #   retention_policy {
#   #     enabled = true
#   #     days    = 5
#   #   }
#   # }

#   # metric {
#   #   category = "AllMetrics"

#   #   retention_policy {
#   #     enabled = true
#   #     days    = 5
#   #   }
#   # }
# }
