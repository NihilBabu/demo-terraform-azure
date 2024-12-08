data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "main" {
  name                        = var.name
  location                    = var.location
  resource_group_name         = var.resource_group
  tags                        = var.tags
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 30
  purge_protection_enabled    = false

  sku_name = "standard"

}

resource "azurerm_key_vault_access_policy" "self" {
  key_vault_id = azurerm_key_vault.main.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id
  key_permissions = [
    "Backup",
    "Create",
    "Decrypt",
    "Delete",
    "Encrypt",
    "Get",
    "Import",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Sign",
    "UnwrapKey",
    "Update",
    "Verify",
    "WrapKey"
  ]
  certificate_permissions = [
    "Backup",
    "Create",
    "Delete",
    "DeleteIssuers",
    "Get",
    "GetIssuers",
    "Import",
    "List",
    "ListIssuers",
    "ManageContacts",
    "ManageIssuers",
    "Purge",
    "Recover",
    "Restore",
    "SetIssuers",
    "Update"
  ]
  secret_permissions = [
    "Backup",
    "Delete",
    "Get",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Set"
  ]
  storage_permissions = [
    "Backup",
    "Delete",
    "DeleteSAS",
    "Get",
    "GetSAS",
    "List",
    "ListSAS",
    "Purge",
    "Recover",
    "RegenerateKey",
    "Restore",
    "Set",
    "SetSAS",
    "Update"
  ]
}

resource "azurerm_key_vault_access_policy" "main" {
  for_each     = var.additional_policy
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = each.key

  key_permissions         = each.value.key_permissions
  certificate_permissions = each.value.certificate_permissions
  secret_permissions      = each.value.secret_permissions
  storage_permissions     = each.value.storage_permissions
}
