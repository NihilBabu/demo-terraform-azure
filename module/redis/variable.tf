variable "name" {
  type = string
}
variable "tags" {
  default     = {}
  description = "Additional resource tags"
  type        = map(string)
}
variable "resource_group" {
  type = string
}
variable "location" {
  type = string
}
variable "capacity" {
  type    = number
  default = 0
}
variable "family" {
  type    = string
  default = "C"
}
variable "sku_name" {
  type    = string
  default = "Standard"
}
variable "enable_non_ssl_port" {
  type    = bool
  default = false
}
variable "subnet" {
  type = string
}
variable "private_dns_id" {
  type = string
}
variable "private_dns_name" {
  type = string
}
