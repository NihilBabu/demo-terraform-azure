variable "name" {
  type = string
}
variable "tags" {
  default     = {}
  description = "Additional resource tags"
  type        = map(string)
}
variable "public_ip_name" {
  type = string
}
variable "resource_group" {
  type = string
}
variable "location" {
  type = string
}

variable "sku_tier" {
  default = "Standard"
  type    = string
}
variable "subnet_id" {
  type = string
}
variable "workspace_id" {
  type = string
}