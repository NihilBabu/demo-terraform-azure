variable "name" {
  type = string
}
variable "location" {
  type = string
}

variable "resource_group" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "tags" {
  default     = {}
  description = "Additional resource tags"
  type        = map(string)
}

variable "service_connection" {
  type = string
}
variable "resource_id" {
  type = string
}