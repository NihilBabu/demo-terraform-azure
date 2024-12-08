variable "name" {
  type = string
}
variable "tags" {
  default     = {}
  description = "Additional resource tags"
  type        = map(string)
}
variable "public_ip_name" {
  type = string
}
variable "resource_group" {
  type = string
}
variable "location" {
  type = string
}
variable "appname" {
  type = string
}
variable "subnet_id" {
  type = string
}
variable "sku_name" {
  type = string
}
variable "tier" {
  type = string
}
variable "capacity" {
  type    = number
  default = 1
}

variable "public_listener" {
  type = bool
}
variable "private_listener" {
  type = object({
    enabled            = bool
    address_allocation = string
    ip_address         = string
  })
  default = {
    enabled            = false
    address_allocation = ""
    ip_address         = ""
  }
}

variable "ssl_certificate" {
  type = map(map(string))
  default = {}
}

variable "frontend_port" {
  type = map(number)
}

variable "backend_address_pool" {
  type = map(list(string))
}

variable "health_prob" {
  type = map(map(string))
}

variable "http_settings" {
  type = map(object({
    port            = number
    protocol        = string
    request_timeout = number
    probe_name      = string
    host_name       = string
  }))
}

variable "https_listener" {
  type = map(object({
    frontend_ip_configuration_name = string
    frontend_port_name             = string
    protocol                       = string
    host_names                     = list(string)
    cert_name                      = string
  }))
}

variable "http_listener" {
  type = map(object({
    frontend_ip_configuration_name = string
    frontend_port_name             = string
    protocol                       = string
    host_names                     = list(string)
  }))
}

variable "redirect_configuration" {
  type = map(object({
    redirect_type        = string
    target_listener_name = string
    include_path         = bool
    include_query_string = bool
  }))
}

variable "routing_rule" {
  type = map(object({
    http_listener_name         = string
    backend_address_pool_name  = string
    backend_http_settings_name = string
    priority                   = number
  }))
}

variable "redirect_routing_rule" {
  type = map(object({
    http_listener_name          = string
    redirect_configuration_name = string
    priority                   = number
  }))
}
