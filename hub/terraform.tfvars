subscription_id    = ""
subscription_short = "csp"
appname            = "nethub"
location           = "UK South"
location_short     = "uks"

vnet_address_space = ["10.223.0.0/24"]
subnet_list = {
  "agw-snet" : ["10.223.0.0/26"],
  "private-agw-snet" : ["10.223.0.64/26"],
  "AzureFirewallSubnet" : ["10.223.0.128/26"]
  "bastion-snet" : ["10.223.0.192/27"]
}

additional_tags = {
  "Subscription" : "nethub",
  "Env" : "prod",
  "Bowner" : "Ecommerce",
  # "Aowner":"",
  # "BU": "",
  "Dept" : "SDGMAPP",
  "Creator" : "Nihil Babu"
}

# peering_uat = {
#   enabled         = true
#   vnet_name       = "csp-uks-u-sdgmapp-vnet"
#   subscription_id = "b649a031-aa8c-4953-9cd7-2d8d53d44e70"
#   resource_group  = "csp-uks-u-sdgmapp-rg"
# }

route_tables = {
  agw-snet-route : {
    subnet : "agw-snet",
    routes : {
      sdgmapp-u-aks-lb : {
        address_prefix : "10.224.2.0/27",
        destination : "10.223.0.132",
        next_hop_type : "VirtualAppliance"
      }
      sdgmapp-u-aks : {
        address_prefix : "10.224.0.0/23",
        destination : "10.223.0.132",
        next_hop_type : "VirtualAppliance"
      }
    }
  },
  bastion-snet-route : {
    subnet : "bastion-snet",
    routes : {
      internet : {
        address_prefix : "0.0.0.0/0",
        destination : "10.223.0.132",
        next_hop_type : "VirtualAppliance"
      }

      oms-1 : {
        address_prefix : "10.200.0.0/24",
        destination : "10.223.0.132",
        next_hop_type : "VirtualAppliance"
      }
    }
  }
}

#################################### app_gw ######################################

app_gw = {

  ssl_certificate = {
    "abc.com" = {
      "data" = "ssl/abc.com.pfx"
    }
  }
  frontend_port = {
    port-80  = 80
    port-443 = 443
  }

  backend_address_pool = {
    "frontend-uat" = ["10.224.2.6"]
    "appgw-uat"    = ["10.224.2.7"]
    "cdr-uat"      = ["10.224.2.8"]
    "cms-uat"      = ["10.224.2.9"]
  }

  health_prob = {
    "frontend-uat" = {
      protocol = "Http"
      path     = "/"
    }
    "appgw-uat" = {
      protocol = "Http"
      path     = "/"
    }
    "cdr-uat" = {
      protocol = "Http"
      path     = "/"
    }
    "cms-uat" = {
      protocol = "Http"
      path     = "/"
    }
  }

  http_settings = {
    "frontend-uat" = {
      port            = 80
      protocol        = "Http"
      request_timeout = 60
      probe_name      = "frontend-uat"
      host_name       = ""
    }
    "appgw-uat" = {
      port            = 80
      protocol        = "Http"
      request_timeout = 60
      probe_name      = "appgw-uat"
      host_name       = ""
    }
    "cdr-uat" = {
      port            = 80
      protocol        = "Http"
      request_timeout = 60
      probe_name      = "cdr-uat"
      host_name       = ""
    }
    "cms-uat" = {
      port            = 80
      protocol        = "Http"
      request_timeout = 60
      probe_name      = "cms-uat"
      host_name       = ""
    }
  }

  https_listener = {
    "frontend-uat-https" = {
      frontend_ip_configuration_name = "public"
      frontend_port_name             = "port-443"
      protocol                       = "Https"
      host_names                     = ["uat.abc.com"]
      cert_name                      = "abc.com"
    }
    "appgw-uat-https" = {
      frontend_ip_configuration_name = "public"
      frontend_port_name             = "port-443"
      protocol                       = "Https"
      host_names                     = ["apiuat.abc.com"]
      cert_name                      = "abc.com"
    }
    "cdr-uat-https" = {
      frontend_ip_configuration_name = "public"
      frontend_port_name             = "port-443"
      protocol                       = "Https"
      host_names                     = ["authuat.abc.com"]
      cert_name                      = "abc.com"
    }
    "cms-uat-https" = {
      frontend_ip_configuration_name = "public"
      frontend_port_name             = "port-443"
      protocol                       = "Https"
      host_names                     = ["cmsuat.abc.com"]
      cert_name                      = "abc.com"
    }
  }

  http_listener = {
    "frontend-uat-http" = {
      frontend_ip_configuration_name = "public"
      frontend_port_name             = "port-80"
      protocol                       = "Http"
      host_names                     = ["uat.abc.com"]
    }
    "appgw-uat-http" = {
      frontend_ip_configuration_name = "public"
      frontend_port_name             = "port-80"
      protocol                       = "Http"
      host_names                     = ["apiuat.abc.com"]
    }
    "cdr-uat-http" = {
      frontend_ip_configuration_name = "public"
      frontend_port_name             = "port-80"
      protocol                       = "Http"
      host_names                     = ["authuat.abc.com"]
    }
    "cms-uat-http" = {
      frontend_ip_configuration_name = "public"
      frontend_port_name             = "port-80"
      protocol                       = "Http"
      host_names                     = ["cmsuat.abc.com"]
    }
  }

  redirect_configuration = {
    "frontend-uat-http" = {
      redirect_type        = "Permanent"
      target_listener_name = "frontend-uat-https"
      include_path         = true
      include_query_string = true
    }
    "appgw-uat-http" = {
      redirect_type        = "Permanent"
      target_listener_name = "appgw-uat-https"
      include_path         = true
      include_query_string = true
    }
    "cdr-uat-http" = {
      redirect_type        = "Permanent"
      target_listener_name = "cdr-uat-https"
      include_path         = true
      include_query_string = true
    }
    "cms-uat-http" = {
      redirect_type        = "Permanent"
      target_listener_name = "cms-uat-https"
      include_path         = true
      include_query_string = true
    }
  }

  routing_rule = {
    "frontend-uat-https" = {
      http_listener_name         = "frontend-uat-https"
      backend_address_pool_name  = "frontend-uat"
      backend_http_settings_name = "frontend-uat"
      priority                   = 110
    }
    "appgw-uat-https" = {
      http_listener_name         = "appgw-uat-https"
      backend_address_pool_name  = "appgw-uat"
      backend_http_settings_name = "appgw-uat"
      priority                   = 120
    }
    "cdr-uat-https" = {
      http_listener_name         = "cdr-uat-https"
      backend_address_pool_name  = "cdr-uat"
      backend_http_settings_name = "cdr-uat"
      priority                   = 130
    }
    "cms-uat-https" = {
      http_listener_name         = "cms-uat-https"
      backend_address_pool_name  = "cms-uat"
      backend_http_settings_name = "cms-uat"
      priority                   = 140
    }
  }

  redirect_routing_rule = {
    "frontend-uat-http" = {
      http_listener_name          = "frontend-uat-http"
      redirect_configuration_name = "frontend-uat-http"
      priority                    = 10
    }
    "appgw-uat-http" = {
      http_listener_name          = "appgw-uat-http"
      redirect_configuration_name = "appgw-uat-http"
      priority                    = 20
    }
    "cdr-uat-http" = {
      http_listener_name          = "cdr-uat-http"
      redirect_configuration_name = "cdr-uat-http"
      priority                    = 30
    }
    "cms-uat-http" = {
      http_listener_name          = "cms-uat-http"
      redirect_configuration_name = "cms-uat-http"
      priority                    = 40
    }
  }
}

#################################### private_app_gw ######################################
# private_app_gw = {

#   ssl_certificate = {
#     # "abc.com" = {
#     #   "key_vault_secret_id" = "https://csp-uks-nethub-kv.vault.azure.net/secrets/abc-com/9feb503717ff4cce880a6033ea713060"
#     # }
#   }
#   frontend_port = {
#     port-80  = 80
#     port-443 = 443
#   }

#   backend_address_pool = {
#     "cdr-admin-uat" = ["10.224.2.10"]
#     "sonarqube"     = ["10.223.0.196"]
#     "kibana-uat"    = ["10.224.2.36"]
#     "akeneo-uat"    = ["10.224.2.11"]
#   }

#   health_prob = {
#     "cdr-admin-uat" = {
#       protocol = "Http"
#       path     = "/"
#     }
#     "sonarqube" = {
#       protocol = "Http"
#       path     = "/"
#     }
#     "kibana-uat" = {
#       protocol = "Https"
#       path     = "/"
#     }
#     "akeneo-uat" = {
#       protocol = "Http"
#       path     = "/"
#     }
#   }

#   http_settings = {
#     "cdr-admin-uat" = {
#       port            = 80
#       protocol        = "Http"
#       request_timeout = 60
#       probe_name      = "cdr-admin-uat"
#       host_name       = ""
#     }
#     "sonarqube" = {
#       port            = 9000
#       protocol        = "Http"
#       request_timeout = 60
#       probe_name      = "sonarqube"
#       host_name       = ""
#     }
#     "kibana-uat" = {
#       port            = 9243
#       protocol        = "Https"
#       request_timeout = 60
#       probe_name      = "kibana-uat"
#       host_name       = "csp-uks-u-sdgmapp-elastic-6c4c9c.kb.uksouth.azure.elastic-cloud.com"
#     }
#     "akeneo-uat" = {
#       port            = 80
#       protocol        = "Http"
#       request_timeout = 60
#       probe_name      = "akeneo-uat"
#       host_name       = "akeneo-uat.abc.com"
#     }
#   }

#   https_listener = {

#     "cdr-admin-uat-https" = {
#       frontend_ip_configuration_name = "private"
#       frontend_port_name             = "port-443"
#       protocol                       = "Https"
#       host_names                     = ["cdruat.abc.com"]
#       cert_name                      = "abc.com"
#     }
#     "sonarqube-https" = {
#       frontend_ip_configuration_name = "private"
#       frontend_port_name             = "port-443"
#       protocol                       = "Https"
#       host_names                     = ["sonar.abc.com"]
#       cert_name                      = "abc.com"
#     }
#     "kibana-uat-https" = {
#       frontend_ip_configuration_name = "private"
#       frontend_port_name             = "port-443"
#       protocol                       = "Https"
#       host_names                     = ["kibana-uat.abc.com"]
#       cert_name                      = "abc.com"
#     }
#     "akeneo-uat-https" = {
#       frontend_ip_configuration_name = "private"
#       frontend_port_name             = "port-443"
#       protocol                       = "Https"
#       host_names                     = ["akeneo-uat.abc.com"]
#       cert_name                      = "abc.com"
#     }
#   }

#   http_listener = {
#     "cdr-admin-uat-http" = {
#       frontend_ip_configuration_name = "private"
#       frontend_port_name             = "port-80"
#       protocol                       = "Http"
#       host_names                     = ["cdruat.abc.com"]
#     }
#     "sonarqube-http" = {
#       frontend_ip_configuration_name = "private"
#       frontend_port_name             = "port-80"
#       protocol                       = "Http"
#       host_names                     = ["sonar.abc.com"]
#     }
#     "kibana-uat-http" = {
#       frontend_ip_configuration_name = "private"
#       frontend_port_name             = "port-80"
#       protocol                       = "Http"
#       host_names                     = ["kibana-uat.abc.com"]
#     }
#     "akeneo-uat-http" = {
#       frontend_ip_configuration_name = "private"
#       frontend_port_name             = "port-80"
#       protocol                       = "Http"
#       host_names                     = ["akeneo-uat.abc.com"]
#     }
#   }

#   redirect_configuration = {
#     "cdr-admin-uat-http" = {
#       redirect_type        = "Permanent"
#       target_listener_name = "cdr-admin-uat-https"
#       include_path         = true
#       include_query_string = true
#     }
#     "sonarqube-http" = {
#       redirect_type        = "Permanent"
#       target_listener_name = "sonarqube-https"
#       include_path         = true
#       include_query_string = true
#     }
#     "kibana-uat-http" = {
#       redirect_type        = "Permanent"
#       target_listener_name = "kibana-uat-https"
#       include_path         = true
#       include_query_string = true
#     }
#     "akeneo-uat-http" = {
#       redirect_type        = "Permanent"
#       target_listener_name = "akeneo-uat-https"
#       include_path         = true
#       include_query_string = true
#     }
#   }

#   routing_rule = {
#     "cdr-admin-uat-https" = {
#       http_listener_name         = "cdr-admin-uat-https"
#       backend_address_pool_name  = "cdr-admin-uat"
#       backend_http_settings_name = "cdr-admin-uat"
#       priority = 210
#     }
#     "sonarqube-https" = {
#       http_listener_name         = "sonarqube-https"
#       backend_address_pool_name  = "sonarqube"
#       backend_http_settings_name = "sonarqube"
#       priority = 220
#     }
#     "kibana-uat-https" = {
#       http_listener_name         = "kibana-uat-https"
#       backend_address_pool_name  = "kibana-uat"
#       backend_http_settings_name = "kibana-uat"
#       priority = 230
#     }
#     "akeneo-uat-https" = {
#       http_listener_name         = "akeneo-uat-https"
#       backend_address_pool_name  = "akeneo-uat"
#       backend_http_settings_name = "akeneo-uat"
#       priority = 240
#     }
#   }

#   redirect_routing_rule = {
#     "cdr-uat-http" = {
#       http_listener_name          = "cdr-admin-uat-http"
#       redirect_configuration_name = "cdr-admin-uat-http"
#       priority = 110
#     }
#     "sonarqube-http" = {
#       http_listener_name          = "sonarqube-http"
#       redirect_configuration_name = "sonarqube-http"
#       priority = 120
#     }
#     "kibana-uat-http" = {
#       http_listener_name          = "kibana-uat-http"
#       redirect_configuration_name = "kibana-uat-http"
#       priority = 130
#     }
#     "akeneo-uat-http" = {
#       http_listener_name          = "akeneo-uat-http"
#       redirect_configuration_name = "akeneo-uat-http"
#       priority = 140
#     }
#   }
# }
