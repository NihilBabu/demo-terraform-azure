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

variable "vnet_id" {
  type = string
}
variable "vnet_name" {
  type = string
}
variable "endpoint_name" {
  type = string
}
variable "subnet_id" {
  type = string
}

variable "service_connection" {
  type = string
}
variable "resource_alias" {
  type = string
}



