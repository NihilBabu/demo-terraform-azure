terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.13.0"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}

locals {
  name_prefix             = "${var.subscription_short}-${var.location_short}-p-${var.appname}-"
  subnet_prefix           = "${var.subscription_short}-${var.location_short}-p-"
  private_endpoint_prefix = "${var.subscription_short}-${var.location_short}-p-${var.appname}-"
  firewall_prefix         = "${var.subscription_short}-${var.location_short}-p-${var.appname}-"
  route_table_prefix      = "${var.subscription_short}-${var.location_short}-p-"
  names = {
    resource_group_name = "${local.name_prefix}rg"
    vnet_name           = "${local.name_prefix}vnet"
    firewall_name       = "${local.firewall_prefix}fw"
    public_ip_name      = "${local.name_prefix}pip"
    bastion_vm_name     = "${local.name_prefix}bastion-vm"
    app_gw_name         = "${local.name_prefix}app-gw"
    private_app_gw_name = "${local.name_prefix}private-app-gw"
    log_analytics_name  = "${local.name_prefix}law"
  }
  tags = {
    app_tier_common  = "common"
    app_tier_network = "NTW"
  }
}

# data "azurerm_key_vault_certificate" "test" {
#   name         = "sharafdg-com"
#   key_vault_id = "/subscriptions/e307c88a-ac42-458a-87ec-556a42ed453a/resourceGroups/csp-uks-p-sdgmapp-tfstate-rg/providers/Microsoft.KeyVault/vaults/csp-uks-nethub-kv"
# }


module "resource_group" {
  name     = local.names.resource_group_name
  source   = "../module/resource_group"
  location = var.location
  tags     = merge({ App-Tier : local.tags.app_tier_common }, var.additional_tags)
}

module "vnet" {
  name           = local.names.vnet_name
  source         = "../module/vnet"
  location       = var.location
  resource_group = module.resource_group.name
  address_space  = var.vnet_address_space
  tags           = merge({ App-Tier : local.tags.app_tier_network }, var.additional_tags)
}

module "subnet" {
  for_each         = var.subnet_list
  name             = each.key == "AzureFirewallSubnet" ? each.key : "${local.subnet_prefix}${each.key}"
  source           = "../module/snet"
  resource_group   = module.resource_group.name
  vnet_name        = module.vnet.name
  address_prefixes = each.value
  depends_on = [
    module.vnet,
  ]
}

module "log_analytics" {
  name           = local.names.log_analytics_name
  source         = "../module/log_analytics"
  resource_group = module.resource_group.name
  location       = var.location
  tags           = merge({ App-Tier : local.tags.app_tier_common }, var.additional_tags)
}

module "firewall" {
  name           = local.names.firewall_name
  source         = "../module/firewall"
  resource_group = module.resource_group.name
  location       = var.location
  tags           = merge({ App-Tier : local.tags.app_tier_network }, var.additional_tags)
  public_ip_name = "${local.names.public_ip_name}-1"
  subnet_id      = "/subscriptions/${var.subscription_id}/resourceGroups/${module.resource_group.name}/providers/Microsoft.Network/virtualNetworks/${module.vnet.name}/subnets/AzureFirewallSubnet"
  workspace_id   = module.log_analytics.id
  depends_on = [
    module.vnet,
    module.subnet
  ]
}

# module "vm" {
#   name            = local.names.bastion_vm_name
#   source          = "../module/vm"
#   resource_group  = module.resource_group.name
#   location        = var.location
#   tags            = merge({ App-Tier : local.tags.app_tier_common }, var.additional_tags)
#   interface_tags  = merge({ App-Tier : local.tags.app_tier_network }, var.additional_tags)
#   subnet_id       = "/subscriptions/${var.subscription_id}/resourceGroups/${module.resource_group.name}/providers/Microsoft.Network/virtualNetworks/${module.vnet.name}/subnets/${local.subnet_prefix}bastion-snet"
#   os_disk_size_gb = 100
#   depends_on = [
#     module.subnet
#   ]
# }


module "route_table" {
  for_each         = var.route_tables
  source           = "../module/route_table"
  name             = "${local.route_table_prefix}${each.key}"
  resource_group   = module.resource_group.name
  location         = var.location
  tags             = merge({ App-Tier : local.tags.app_tier_network }, var.additional_tags)
  subnet_id_prefix = "/subscriptions/${var.subscription_id}/resourceGroups/${module.resource_group.name}/providers/Microsoft.Network/virtualNetworks/${module.vnet.name}/subnets/${local.subnet_prefix}"
  subnet           = each.value.subnet
  routes           = each.value.routes
  depends_on = [
    module.subnet
  ]
}


module "app_gw" {
  name                   = local.names.app_gw_name
  source                 = "../module/app_gw"
  resource_group         = module.resource_group.name
  location               = var.location
  tags                   = merge({ App-Tier : local.tags.app_tier_network }, var.additional_tags)
  appname                = "sdgmapp"
  public_ip_name         = "${local.names.public_ip_name}-2"
  subnet_id              = "/subscriptions/${var.subscription_id}/resourceGroups/${module.resource_group.name}/providers/Microsoft.Network/virtualNetworks/${module.vnet.name}/subnets/${local.subnet_prefix}agw-snet"
  sku_name               = "Standard_v2"
  tier                   = "Standard_v2"
  capacity               = 1
  public_listener        = true
  ssl_certificate        = var.app_gw.ssl_certificate
  frontend_port          = var.app_gw.frontend_port
  backend_address_pool   = var.app_gw.backend_address_pool
  health_prob            = var.app_gw.health_prob
  http_settings          = var.app_gw.http_settings
  https_listener         = var.app_gw.https_listener
  http_listener          = var.app_gw.http_listener
  redirect_configuration = var.app_gw.redirect_configuration
  routing_rule           = var.app_gw.routing_rule
  redirect_routing_rule  = var.app_gw.redirect_routing_rule
  # private_listener       = { enabled = true, address_allocation = "Static", ip_address = "10.223.0.60" }
  depends_on = [
    module.subnet
  ]
}

# module "private_app_gw" {
#   name                   = local.names.private_app_gw_name
#   source                 = "../module/app_gw"
#   resource_group         = module.resource_group.name
#   location               = var.location
#   tags                   = merge({ App-Tier : local.tags.app_tier_network }, var.additional_tags)
#   appname                = "sdgmapp"
#   subnet_id              = "/subscriptions/${var.subscription_id}/resourceGroups/${module.resource_group.name}/providers/Microsoft.Network/virtualNetworks/${module.vnet.name}/subnets/${local.subnet_prefix}private-agw-snet"
#   sku_name               = "Standard_v2"
#   tier                   = "Standard_v2"
#   capacity               = 1
#   public_listener        = true
#   public_ip_name         = "${local.names.public_ip_name}-3"
#   private_listener       = { enabled = true, address_allocation = "Static", ip_address = "10.223.0.100" }
#   ssl_certificate        = var.private_app_gw.ssl_certificate
#   frontend_port          = var.private_app_gw.frontend_port
#   backend_address_pool   = var.private_app_gw.backend_address_pool
#   health_prob            = var.private_app_gw.health_prob
#   http_settings          = var.private_app_gw.http_settings
#   https_listener         = var.private_app_gw.https_listener
#   http_listener          = var.private_app_gw.http_listener
#   redirect_configuration = var.private_app_gw.redirect_configuration
#   routing_rule           = var.private_app_gw.routing_rule
#   redirect_routing_rule  = var.private_app_gw.redirect_routing_rule

#   depends_on = [
#     module.subnet
#   ]
# }

































