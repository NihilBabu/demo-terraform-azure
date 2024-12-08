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
variable "subnet_id_prefix" {
  type = string
}

variable "subnet" {
  type = string
}

variable "routes" {
  type = map(object({
    address_prefix= string
    destination= string
    next_hop_type= string
  }))
}

