output "name" {
  description = "resource group name"
  value       = azurerm_resource_group.main.name
}
output "location" {
  description = "resource group location name"
  value       = azurerm_resource_group.main.location
}