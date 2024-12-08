variable "name" {
  type = string
}
variable "resource_group" {
  type = string
}
variable "vnet_name" {
  type = string
}
variable "service_endpoints" {
  default = []
  type    = list(string)
}
variable "address_prefixes" {
  type = list(string)
}
# variable "network_policies_enabled" {
#   default = true
#   type    = bool
# }
