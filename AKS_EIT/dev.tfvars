subscription_id=""

addional_tags = {
  "Environment" : "dev"
  "CreatedOnDate" : "2022-06-20T13:28:37.2463530Z"
}

vnet_address_space = ["10.103.0.0/19"]

subnet_list = {
    "aks-un-dev-01": ["10.103.0.0/20"],
    "agw-un-dev-01": ["10.103.16.0/24"],
    "lb-un-dev-01": ["10.103.17.0/25"],
    "ep-un-dev-01": ["10.103.17.128/25"],
}
app_gw_subnet = "agw-un-dev-01"
aks_subnet = "aks-un-dev-01"

# app_gw = {

#   ssl_certificate = {
 
#   }

#   frontend_port = {
#     port-80  = 80
#     # port-443 = 443
#   }

#   backend_address_pool = {
#     "test"      = ["10.224.2.9"]
#   }

#   health_prob = {
#     "test" = {
#       protocol = "Http"
#       path     = "/"
#     }
#   }

#   http_settings = {
#     "test" = {
#       port            = 80
#       protocol        = "Http"
#       request_timeout = 60
#       probe_name      = "test"
#       host_name       = ""
#     }
#   }

#   https_listener = {
  
#   }

#   http_listener = {
#     "test" = {
#       frontend_ip_configuration_name = "public"
#       frontend_port_name             = "port-80"
#       protocol                       = "Http"
#       host_names                     = ["test.abc.com"]
#     }
#   }

#   redirect_configuration = {
#   }

#   routing_rule = {
#     "frontend-uat-https" = {
#       http_listener_name         = "test"
#       backend_address_pool_name  = "test"
#       backend_http_settings_name = "test"
#       priority                   = 10
#     }
#   }
#   redirect_routing_rule = {
#   }
# }


route_tables = {
  rt-aks-un-dev-01 : {
    subnet : "aks-un-dev-01"
    routes : {
      internet : {
        address_prefix: "0.0.0.0/0",
        destination: "-",
        next_hop_type: "Internet"
      }
    }
  }
}