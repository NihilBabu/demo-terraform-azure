variable "name" {
  type = string
}

variable "interface_tags" {
  default     = {}
  description = "Additional resource tags"
  type        = map(string)
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
variable "subnet_id" {
  type = string
}
variable "os_disk_size_gb" {
  type    = number
  default = 30
}
