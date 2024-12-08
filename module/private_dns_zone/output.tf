output "name" {
  description = "name of zone"
  value       = azurerm_private_dns_zone.main.name
}
output "id" {
  description = "id of dns zone"
  value       = azurerm_private_dns_zone.main.id
}