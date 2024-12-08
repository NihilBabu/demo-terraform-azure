variable "subscription_id" {
  default = "e307c88a-ac42-458a-87ec-556a42ed453a"
  type    = string
}
variable "subscription_short" {
  type = string
}
variable "location" {
  default = "UK South"
  type    = string
}
variable "location_short" {
  type = string
}
variable "appname" {
  type = string
}

variable "additional_tags" {
  default     = {}
  description = "Additional resource tags"
  type        = map(string)
}

variable "vnet_address_space" {
  type = list(string)
}

variable "subnet_list" {
  type = map(list(string))
}

variable "peering_uat" {
  type = object({
    enabled         = bool
    vnet_name       = string
    subscription_id = string
    resource_group  = string
  })
  default = {
    enabled         = false
    vnet_name       = ""
    subscription_id = ""
    resource_group  = ""
  }
}


variable "route_tables" {
  type = map(object({
    subnet = string
    routes = map(object({
      address_prefix = string
      destination    = string
    }))
  }))
}


variable "app_gw" {
  type = object({
    ssl_certificate      = map(map(string))
    frontend_port        = map(number)
    backend_address_pool = map(list(string))
    health_prob          = map(map(string))
    http_settings = map(object({
      port            = number
      protocol        = string
      request_timeout = number
      probe_name      = string
      host_name       = string
    }))
    https_listener = map(object({
      frontend_ip_configuration_name = string
      frontend_port_name             = string
      protocol                       = string
      host_names                     = list(string)
      cert_name                      = string
    }))
    http_listener = map(object({
      frontend_ip_configuration_name = string
      frontend_port_name             = string
      protocol                       = string
      host_names                     = list(string)
    }))
    redirect_configuration = map(object({
      redirect_type        = string
      target_listener_name = string
      include_path         = bool
      include_query_string = bool
    }))
    routing_rule = map(object({
      http_listener_name         = string
      backend_address_pool_name  = string
      backend_http_settings_name = string
    }))
    redirect_routing_rule = map(object({
      http_listener_name          = string
      redirect_configuration_name = string
    }))
  })
}


variable "private_app_gw" {
  type = object({
    ssl_certificate      = map(map(string))
    frontend_port        = map(number)
    backend_address_pool = map(list(string))
    health_prob          = map(map(string))
    http_settings = map(object({
      port            = number
      protocol        = string
      request_timeout = number
      probe_name      = string
      host_name       = string
    }))
    https_listener = map(object({
      frontend_ip_configuration_name = string
      frontend_port_name             = string
      protocol                       = string
      host_names                     = list(string)
      cert_name                      = string
    }))
    http_listener = map(object({
      frontend_ip_configuration_name = string
      frontend_port_name             = string
      protocol                       = string
      host_names                     = list(string)
    }))
    redirect_configuration = map(object({
      redirect_type        = string
      target_listener_name = string
      include_path         = bool
      include_query_string = bool
    }))
    routing_rule = map(object({
      http_listener_name         = string
      backend_address_pool_name  = string
      backend_http_settings_name = string
    }))
    redirect_routing_rule = map(object({
      http_listener_name          = string
      redirect_configuration_name = string
    }))
  })
}
