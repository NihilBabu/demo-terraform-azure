variable "name" {
  type = string
}
variable "resource_group" {
  type = string
}

variable "location" {
  type = string
}

variable "tags" {
  default     = {}
  description = "Additional resource tags"
  type        = map(string)
}

variable "lb_subnet_id" {
  type = string
}

variable "frontend_ip_configuration_ids" {
  type = list(string)
}

