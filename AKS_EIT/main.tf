terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.99.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-shared-un-p-01"
    storage_account_name = "saaksappuntf01"
    container_name       = "aks-eit-tf"
    key                  = "terraform.tfstate"
    subscription_id      = "1bde07cf-02b6-4c27-9431-1ab1f2f2306d"
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

locals {
  name = {
    prefix = {
      name                = "${var.appname}-${var.location_short}-${substr(terraform.workspace, 0, 1)}"
      resource_group_name = "rg-${var.appname}-${var.location_short}-${substr(terraform.workspace, 0, 1)}"
      vnet_name           = "vnet-${var.appname}-${var.location_short}-${substr(terraform.workspace, 0, 1)}"
      agw_name            = "agw-${var.appname}-${var.location_short}-${substr(terraform.workspace, 0, 1)}"
      aks_name            = "aks-${var.appname}-${var.location_short}-${substr(terraform.workspace, 0, 1)}"
    }
  }
}

module "resource_group" {
  source   = "../module/resource_group"
  name     = "${local.name.prefix.resource_group_name}-01"
  tags     = merge(var.tags, var.addional_tags)
  location = var.location
}

module "vnet" {
  source         = "../module/vnet"
  name           = "${local.name.prefix.vnet_name}-01"
  tags           = merge(var.tags, var.addional_tags)
  location       = var.location
  resource_group = module.resource_group.name
  address_space  = var.vnet_address_space
}

module "subnet" {
  for_each         = var.subnet_list
  source           = "../module/snet"
  name             = "snet-${each.key}"
  resource_group   = module.resource_group.name
  vnet_name        = module.vnet.name
  address_prefixes = each.value
}

module "agw" {
  source                 = "../module/app_gw"
  name                   = "${local.name.prefix.agw_name}-01"
  resource_group         = module.resource_group.name
  tags                   = merge(var.tags, var.addional_tags)
  location               = var.location
  public_ip_name         = "pip-aksapp-un-${substr(terraform.workspace, 0, 1)}-01"
  appname                = var.appname
  # subnet_id              = "/subscriptions/${var.subscription_id}/resourceGroups/${module.resource_group.name}/providers/Microsoft.Network/virtualNetworks/${module.vnet.name}/subnets/snet-agw-un-dev-01"
  # subnet_id              = "/subscriptions/${var.subscription_id}/resourceGroups/${module.resource_group.name}/providers/Microsoft.Network/virtualNetworks/${module.vnet.name}/subnets/snet-agw-un-prd-01"
  subnet_id              = "/subscriptions/${var.subscription_id}/resourceGroups/${module.resource_group.name}/providers/Microsoft.Network/virtualNetworks/${module.vnet.name}/subnets/snet-${var.app_gw_subnet}"
  sku_name               = "WAF_v2"
  tier                   = "WAF_v2"
  capacity               = 1
  public_listener        = true
  frontend_port          = var.app_gw.frontend_port
  backend_address_pool   = var.app_gw.backend_address_pool
  health_prob            = var.app_gw.health_prob
  http_settings          = var.app_gw.http_settings
  https_listener         = var.app_gw.https_listener
  http_listener          = var.app_gw.http_listener
  redirect_configuration = var.app_gw.redirect_configuration
  routing_rule           = var.app_gw.routing_rule
  redirect_routing_rule  = var.app_gw.redirect_routing_rule
  depends_on = [
    module.subnet
  ]
}

module "aks" {
  source              = "../module/aks"
  name                = "${local.name.prefix.aks_name}-01"
  resource_group      = module.resource_group.name
  tags                = merge(var.tags, var.addional_tags)
  node_resource_group = "${local.name.prefix.resource_group_name}-02"
  location            = var.location
  availability_zones  = []
  node_size           = "Standard_D4S_v3"
  # cluster_subnet_id   = "/subscriptions/${var.subscription_id}/resourceGroups/${module.resource_group.name}/providers/Microsoft.Network/virtualNetworks/${module.vnet.name}/subnets/snet-aks-un-dev-01"
  # cluster_subnet_id   = "/subscriptions/${var.subscription_id}/resourceGroups/${module.resource_group.name}/providers/Microsoft.Network/virtualNetworks/${module.vnet.name}/subnets/snet-aks-un-prd-01"
  cluster_subnet_id   = "/subscriptions/${var.subscription_id}/resourceGroups/${module.resource_group.name}/providers/Microsoft.Network/virtualNetworks/${module.vnet.name}/subnets/snet-${var.aks_subnet}"
  outbound_type       = "loadBalancer"
  depends_on = [
    module.subnet
  ]
}
