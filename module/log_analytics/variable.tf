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