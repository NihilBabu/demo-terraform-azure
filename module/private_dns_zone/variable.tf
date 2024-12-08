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
variable "vnet_id" {
  type = string
}
variable "vnet_name" {
  type = string
}
