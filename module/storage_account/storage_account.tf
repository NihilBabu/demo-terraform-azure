resource "azurerm_storage_account" "example" {
  name                     = var.name
  resource_group_name      = var.resource_group
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type

  tags = var.tags
}

resource "azurerm_storage_container" "example" {
  count                 = length(var.containers)
  name                  = var.containers[count.index].name
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = var.containers[count.index].access_type
}

resource "azurerm_storage_share" "example" {
  count                = length(var.file_share)
  name                 = var.file_share[count.index].name
  storage_account_name = azurerm_storage_account.example.name
  quota                = var.file_share[count.index].quota
}
