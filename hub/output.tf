
# # output "id" {
# #   description = "subnets id"
# #   value       = module.subnet.id
# # }
# output "subnet_ids" {
#   value = tomap({
#     for k, inst in module.subnet : k => inst.id
#   })
# }
# output "app_gw_mi" {
#   value = module.app_gw.mi
#   # value = tomap({
#   #   for k, inst in module.app_gw : k => inst.mi
#   # })
# }

# output "cert-id-test" {
#   value = data.azurerm_key_vault_certificate.test.secret_id
# }
