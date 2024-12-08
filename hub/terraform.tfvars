subscription_id    = "e307c88a-ac42-458a-87ec-556a42ed453a"
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
  "Dept" : "SDGMAPP"
}

peering_uat = {
  enabled         = true
  vnet_name       = "csp-uks-u-sdgmapp-vnet"
  subscription_id = "b649a031-aa8c-4953-9cd7-2d8d53d44e70"
  resource_group  = "csp-uks-u-sdgmapp-rg"
}

route_tables = {
  agw-snet-route : {
    subnet : "agw-snet",
    routes : {
      sdgmapp-u-aks-lb : {
        address_prefix : "10.224.2.0/27",
        destination : "10.223.0.132"
      }
      sdgmapp-u-aks : {
        address_prefix : "10.224.0.0/23",
        destination : "10.223.0.132"
      }
    }
  }
  private-agw-snet-route : {
    subnet : "private-agw-snet",
    routes : {
      vpn-1 : {
        address_prefix : "192.196.2.0/24",
        destination : "10.223.0.132"
      }
      vpn-2 : {
        address_prefix : "10.16.10.0/24",
        destination : "10.223.0.132"
      }
      vpn-3 : {
        address_prefix : "10.16.60.0/23",
        destination : "10.223.0.132"
      }
      vpn-4 : {
        address_prefix : "10.16.13.0/24",
        destination : "10.223.0.132"
      }
      vpn-5 : {
        address_prefix : "10.3.0.0/23",
        destination : "10.223.0.132"
      }
      vpn-6 : {
        address_prefix : "172.17.60.0/24",
        destination : "10.223.0.132"
      }
      vpn-7 : {
        address_prefix : "10.16.20.0/23",
        destination : "10.223.0.132"
      }
      vpn-8 : {
        address_prefix : "10.16.22.0/24",
        destination : "10.223.0.132"
      }
      vpn-9 : {
        address_prefix : "10.202.1.0/24",
        destination : "10.223.0.132"
      }
      vpn-10 : {
        address_prefix : "10.16.25.0/24",
        destination : "10.223.0.132"
      }

    }
  }
  bastion-snet-route : {
    subnet : "bastion-snet",
    routes : {
      internet : {
        address_prefix : "0.0.0.0/0",
        destination : "10.223.0.132"
      }
      vpn-1 : {
        address_prefix : "192.196.2.0/24",
        destination : "10.223.0.132"
      }
      vpn-2 : {
        address_prefix : "10.16.10.0/24",
        destination : "10.223.0.132"
      }
      vpn-3 : {
        address_prefix : "10.16.60.0/23",
        destination : "10.223.0.132"
      }
      vpn-4 : {
        address_prefix : "10.16.13.0/24",
        destination : "10.223.0.132"
      }
      vpn-5 : {
        address_prefix : "10.3.0.0/23",
        destination : "10.223.0.132"
      }
      vpn-6 : {
        address_prefix : "172.17.60.0/24",
        destination : "10.223.0.132"
      }
      vpn-7 : {
        address_prefix : "10.16.20.0/23",
        destination : "10.223.0.132"
      }
      vpn-8 : {
        address_prefix : "10.16.22.0/24",
        destination : "10.223.0.132"
      }
      vpn-9 : {
        address_prefix : "10.202.1.0/24",
        destination : "10.223.0.132"
      }
      vpn-10 : {
        address_prefix : "10.16.25.0/24",
        destination : "10.223.0.132"
      }
      oms-1 : {
        address_prefix : "10.200.0.0/24",
        destination : "10.223.0.132"
      }
    }
  }
}

#################################### app_gw ######################################

app_gw = {

  ssl_certificate = {
    "sharafdg.com" = {
      "key_vault_secret_id" = "https://csp-uks-nethub-kv.vault.azure.net/secrets/sharafdg-com/9feb503717ff4cce880a6033ea713060"
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
      host_names                     = ["uat.sharafdg.com"]
      cert_name                      = "sharafdg.com"
    }
    "appgw-uat-https" = {
      frontend_ip_configuration_name = "public"
      frontend_port_name             = "port-443"
      protocol                       = "Https"
      host_names                     = ["apiuat.sharafdg.com"]
      cert_name                      = "sharafdg.com"
    }
    "cdr-uat-https" = {
      frontend_ip_configuration_name = "public"
      frontend_port_name             = "port-443"
      protocol                       = "Https"
      host_names                     = ["authuat.sharafdg.com"]
      cert_name                      = "sharafdg.com"
    }
    "cms-uat-https" = {
      frontend_ip_configuration_name = "public"
      frontend_port_name             = "port-443"
      protocol                       = "Https"
      host_names                     = ["cmsuat.sharafdg.com"]
      cert_name                      = "sharafdg.com"
    }
  }

  http_listener = {
    "frontend-uat-http" = {
      frontend_ip_configuration_name = "public"
      frontend_port_name             = "port-80"
      protocol                       = "Http"
      host_names                     = ["uat.sharafdg.com"]
    }
    "appgw-uat-http" = {
      frontend_ip_configuration_name = "public"
      frontend_port_name             = "port-80"
      protocol                       = "Http"
      host_names                     = ["apiuat.sharafdg.com"]
    }
    "cdr-uat-http" = {
      frontend_ip_configuration_name = "public"
      frontend_port_name             = "port-80"
      protocol                       = "Http"
      host_names                     = ["authuat.sharafdg.com"]
    }
    "cms-uat-http" = {
      frontend_ip_configuration_name = "public"
      frontend_port_name             = "port-80"
      protocol                       = "Http"
      host_names                     = ["cmsuat.sharafdg.com"]
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
    }
    "appgw-uat-https" = {
      http_listener_name         = "appgw-uat-https"
      backend_address_pool_name  = "appgw-uat"
      backend_http_settings_name = "appgw-uat"
    }
    "cdr-uat-https" = {
      http_listener_name         = "cdr-uat-https"
      backend_address_pool_name  = "cdr-uat"
      backend_http_settings_name = "cdr-uat"
    }
    "cms-uat-https" = {
      http_listener_name         = "cms-uat-https"
      backend_address_pool_name  = "cms-uat"
      backend_http_settings_name = "cms-uat"
    }
  }

  redirect_routing_rule = {
    "frontend-uat-http" = {
      http_listener_name          = "frontend-uat-http"
      redirect_configuration_name = "frontend-uat-http"
    }
    "appgw-uat-http" = {
      http_listener_name          = "appgw-uat-http"
      redirect_configuration_name = "appgw-uat-http"
    }
    "cdr-uat-http" = {
      http_listener_name          = "cdr-uat-http"
      redirect_configuration_name = "cdr-uat-http"
    }
    "cms-uat-http" = {
      http_listener_name          = "cms-uat-http"
      redirect_configuration_name = "cms-uat-http"
    }
  }
}

#################################### private_app_gw ######################################
private_app_gw = {

  ssl_certificate = {
    "sharafdg.com" = {
      "key_vault_secret_id" = "https://csp-uks-nethub-kv.vault.azure.net/secrets/sharafdg-com/9feb503717ff4cce880a6033ea713060"
    }
  }
  frontend_port = {
    port-80  = 80
    port-443 = 443
  }

  backend_address_pool = {
    "cdr-admin-uat" = ["10.224.2.10"]
    "sonarqube"     = ["10.223.0.196"]
    "kibana-uat"    = ["10.224.2.36"]
    "akeneo-uat"    = ["10.224.2.11"]
  }

  health_prob = {
    "cdr-admin-uat" = {
      protocol = "Http"
      path     = "/"
    }
    "sonarqube" = {
      protocol = "Http"
      path     = "/"
    }
    "kibana-uat" = {
      protocol = "Https"
      path     = "/"
    }
    "akeneo-uat" = {
      protocol = "Http"
      path     = "/"
    }
  }

  http_settings = {
    "cdr-admin-uat" = {
      port            = 80
      protocol        = "Http"
      request_timeout = 60
      probe_name      = "cdr-admin-uat"
      host_name       = ""
    }
    "sonarqube" = {
      port            = 9000
      protocol        = "Http"
      request_timeout = 60
      probe_name      = "sonarqube"
      host_name       = ""
    }
    "kibana-uat" = {
      port            = 9243
      protocol        = "Https"
      request_timeout = 60
      probe_name      = "kibana-uat"
      host_name       = "csp-uks-u-sdgmapp-elastic-6c4c9c.kb.uksouth.azure.elastic-cloud.com"
    }
    "akeneo-uat" = {
      port            = 80
      protocol        = "Http"
      request_timeout = 60
      probe_name      = "akeneo-uat"
      host_name       = "akeneo-uat.sharafdg.com"
    }
  }

  https_listener = {

    "cdr-admin-uat-https" = {
      frontend_ip_configuration_name = "private"
      frontend_port_name             = "port-443"
      protocol                       = "Https"
      host_names                     = ["cdruat.sharafdg.com"]
      cert_name                      = "sharafdg.com"
    }
    "sonarqube-https" = {
      frontend_ip_configuration_name = "private"
      frontend_port_name             = "port-443"
      protocol                       = "Https"
      host_names                     = ["sonar.sharafdg.com"]
      cert_name                      = "sharafdg.com"
    }
    "kibana-uat-https" = {
      frontend_ip_configuration_name = "private"
      frontend_port_name             = "port-443"
      protocol                       = "Https"
      host_names                     = ["kibana-uat.sharafdg.com"]
      cert_name                      = "sharafdg.com"
    }
    "akeneo-uat-https" = {
      frontend_ip_configuration_name = "private"
      frontend_port_name             = "port-443"
      protocol                       = "Https"
      host_names                     = ["akeneo-uat.sharafdg.com"]
      cert_name                      = "sharafdg.com"
    }
  }

  http_listener = {
    "cdr-admin-uat-http" = {
      frontend_ip_configuration_name = "private"
      frontend_port_name             = "port-80"
      protocol                       = "Http"
      host_names                     = ["cdruat.sharafdg.com"]
    }
    "sonarqube-http" = {
      frontend_ip_configuration_name = "private"
      frontend_port_name             = "port-80"
      protocol                       = "Http"
      host_names                     = ["sonar.sharafdg.com"]
    }
    "kibana-uat-http" = {
      frontend_ip_configuration_name = "private"
      frontend_port_name             = "port-80"
      protocol                       = "Http"
      host_names                     = ["kibana-uat.sharafdg.com"]
    }
    "akeneo-uat-http" = {
      frontend_ip_configuration_name = "private"
      frontend_port_name             = "port-80"
      protocol                       = "Http"
      host_names                     = ["akeneo-uat.sharafdg.com"]
    }
  }

  redirect_configuration = {
    "cdr-admin-uat-http" = {
      redirect_type        = "Permanent"
      target_listener_name = "cdr-admin-uat-https"
      include_path         = true
      include_query_string = true
    }
    "sonarqube-http" = {
      redirect_type        = "Permanent"
      target_listener_name = "sonarqube-https"
      include_path         = true
      include_query_string = true
    }
    "kibana-uat-http" = {
      redirect_type        = "Permanent"
      target_listener_name = "kibana-uat-https"
      include_path         = true
      include_query_string = true
    }
    "akeneo-uat-http" = {
      redirect_type        = "Permanent"
      target_listener_name = "akeneo-uat-https"
      include_path         = true
      include_query_string = true
    }
  }

  routing_rule = {
    "cdr-admin-uat-https" = {
      http_listener_name         = "cdr-admin-uat-https"
      backend_address_pool_name  = "cdr-admin-uat"
      backend_http_settings_name = "cdr-admin-uat"
    }
    "sonarqube-https" = {
      http_listener_name         = "sonarqube-https"
      backend_address_pool_name  = "sonarqube"
      backend_http_settings_name = "sonarqube"
    }
    "kibana-uat-https" = {
      http_listener_name         = "kibana-uat-https"
      backend_address_pool_name  = "kibana-uat"
      backend_http_settings_name = "kibana-uat"
    }
    "akeneo-uat-https" = {
      http_listener_name         = "akeneo-uat-https"
      backend_address_pool_name  = "akeneo-uat"
      backend_http_settings_name = "akeneo-uat"
    }
  }

  redirect_routing_rule = {
    "cdr-uat-http" = {
      http_listener_name          = "cdr-admin-uat-http"
      redirect_configuration_name = "cdr-admin-uat-http"
    }
    "sonarqube-http" = {
      http_listener_name          = "sonarqube-http"
      redirect_configuration_name = "sonarqube-http"
    }
    "kibana-uat-http" = {
      http_listener_name          = "kibana-uat-http"
      redirect_configuration_name = "kibana-uat-http"
    }
    "akeneo-uat-http" = {
      http_listener_name          = "akeneo-uat-http"
      redirect_configuration_name = "akeneo-uat-http"
    }
  }
}
