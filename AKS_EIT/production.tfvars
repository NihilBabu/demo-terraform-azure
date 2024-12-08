subscription_id="1bde07cf-02b6-4c27-9431-1ab1f2f2306d"


addional_tags = {
  "Environment" : "prd"
  "CreatedOnDate" : "2022-06-20T13:28:37.2463530Z"
}

vnet_address_space = ["10.102.192.0/19"]

subnet_list = {
    "aks-un-prd-01": ["10.102.192.0/20"],
    "agw-un-prd-01": ["10.102.208.0/24"],
    "lb-un-prd-01": ["10.102.209.0/25"],
    "ep-un-prd-01": ["10.102.209.128/25"],
}
app_gw_subnet = "agw-un-prd-01"
aks_subnet = "aks-un-prd-01"

app_gw = {

  ssl_certificate = {
 
  }

  frontend_port = {
    port-80  = 80
    # port-443 = 443
  }

  backend_address_pool = {
    "test"      = ["10.224.2.9"]
  }

  health_prob = {
    "test" = {
      protocol = "Http"
      path     = "/"
    }
  }

  http_settings = {
    "test" = {
      port            = 80
      protocol        = "Http"
      request_timeout = 60
      probe_name      = "test"
      host_name       = ""
    }
  }

  https_listener = {
  
  }

  http_listener = {
    "test" = {
      frontend_ip_configuration_name = "public"
      frontend_port_name             = "port-80"
      protocol                       = "Http"
      host_names                     = ["test.abc.com"]
    }
  }

  redirect_configuration = {
  }

  routing_rule = {
    "frontend-uat-https" = {
      http_listener_name         = "test"
      backend_address_pool_name  = "test"
      backend_http_settings_name = "test"
      priority                   = 10
    }
  }
  redirect_routing_rule = {
  }
}


route_tables = {
#   rt-aks-un-prd-01 : {
#     subnet : "aks-un-prd-01"
#     routes : {
#       internet : {
#         address_prefix: "0.0.0.0/0",
#         destination: "-",
#         next_hop_type: "Internet"
#       }
#     }
#   }
}