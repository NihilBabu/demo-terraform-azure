resource "azurerm_kubernetes_cluster" "main" {
  name                    = var.name
  location                = var.location
  resource_group_name     = var.resource_group
  tags                    = var.tags
  private_cluster_enabled = true
  dns_prefix              = var.name
  node_resource_group     = var.node_resource_group
  # local_account_disabled  = true

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
    # service_cidr       = "10.0.0.0/16"
    # docker_bridge_cidr = "172.17.0.1/16"
    # dns_service_ip     = "10.0.0.10"
    outbound_type  = var.outbound_type
    network_policy = "calico"
  }

  default_node_pool {
    name                 = "default"
    tags                 = var.tags
    max_count            = 2
    min_count            = 1
    auto_scaling_enabled = true
    vm_size              = "Standard_DS2_v2"
    vnet_subnet_id       = var.cluster_subnet_id
  }

  identity {
    type = "SystemAssigned"
  }

  # azure_active_directory_role_based_access_control {
  #   # admin_group_object_ids = var.admin_group_id
  #   azure_rbac_enabled     = true
  # }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}


resource "azurerm_kubernetes_cluster_node_pool" "example" {
  name                  = "userpool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vm_size               = var.node_size
  node_count            = 1
  max_count             = var.node_max_count
  min_count             = var.node_min_count
  auto_scaling_enabled  = true
  mode                  = "User"
  vnet_subnet_id        = var.cluster_subnet_id
  tags                  = var.tags
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

# data "azurerm_client_config" "current" {}

# resource "azurerm_key_vault_access_policy" "self" {

#   key_vault_id = var.key_vault_id
#   tenant_id    = data.azurerm_client_config.current.tenant_id
#   object_id    = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id

#   secret_permissions = [
#     #"delete",
#     "list",
#     "get",
#     #"set",
#     #"recover",
#     #"backup",
#     #"restore",
#   ]
# }

