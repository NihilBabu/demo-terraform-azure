output "name" {
  description = "vnet name"
  value       = azurerm_virtual_network.main.name
}
output "id" {
  description = "vnet id"
  value       = azurerm_virtual_network.main.id
}
output "location" {
  description = "resource group location name"
  value       = azurerm_virtual_network.main.location
}