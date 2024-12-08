variable "name" {
  type = string
}
variable "location" {
  type = string
}
variable "resource_group" {
  type = string
}
variable "tags" {
  default     = {}
  description = "Additional resource tags"
  type        = map(string)
}
variable "address_space" {
  type = list(string)
}

variable "peering" {
  type = object({
    enable             = bool
    vnet_id            = string
    subscription_short = string
    location_short     = string
    environment        = string
    appname            = string
    resource_group     = string
  })
  default = {
    enable             = false
    vnet_id            = ""
    subscription_short = ""
    location_short     = ""
    environment        = ""
    appname            = ""
    resource_group     = ""
  }
}
