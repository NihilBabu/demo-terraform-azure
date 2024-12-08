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
variable "admin_user" {
  default = "mysqladminun"
  type    = string
}
variable "sku" {
  type = string
}
variable "storage_mb" {
  default = "5120"
  type    = number
}
variable "mysql_version" {
  default = "8.0"
  type    = string
}
variable "subnet_id" {
  type = string
}
variable "private_dns_name" {
  type = string
}
variable "private_dns_id" {
  type = string
}
variable "key_vault" {
  type = string
}
variable "ssl_enabled" {
  type = bool
  default = true
}

variable "ssl_version" {
  type = string
  default = "TLS1_2"
}

