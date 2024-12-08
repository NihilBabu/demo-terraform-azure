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
variable "node_resource_group" {
  type = string
}
variable "location" {
  type = string
}

variable "availability_zones" {
  type = list(string)
  default = ["1", "2", "3"]
}
# variable "acr_id" {
#   type = string
# }

variable "node_size" {
  default = "Standard_D4S_v3"
  type    = string
}

variable "cluster_subnet_id" {
  type = string
}
variable "key_vault_id" {
  type = string
  default=""
}

variable "node_min_count" {
  type    = number
  default = 1
}
variable "node_max_count" {
  type    = number
  default = 2
}
variable "admin_group_id" {
  type    = list(string)
  default = []
}
variable "outbound_type" {
  type    = string
  default = "userDefinedRouting"
}
