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
variable "account_tier" {
  type    = string
  default = "Standard"
}
variable "account_replication_type" {
  type    = string
  default = "LRS"
}
variable "containers" {
  type = list(object({
    name        = string
    access_type = string
  }))
  default = []
}
variable "file_share" {
  type = list(object({
    name  = string
    quota = number
  }))
  default = []
}
