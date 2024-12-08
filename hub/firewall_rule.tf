
locals {
  uat = {
    aks_subnet   = "10.224.0.0/23"
    plink_subnet = "10.224.2.32/27"
    akslb_subnet = "10.224.2.0/27"
  }
  nethub = {
    firewall_snet    = "10.223.0.128/26"
    bastion_snet     = "10.223.0.192/27"
    appgw_snet       = "10.223.0.0/26"
    private_agw_snet = "10.223.0.64/26"

  }

  vpn = {
    peering = ["192.196.2.0/24", "10.16.10.0/24", "10.16.60.0/23", "10.16.13.0/24", "10.3.0.0/23", "172.17.60.0/24", "10.16.20.0/23", "10.16.22.0/24", "10.202.1.0/24", "10.16.25.0/24"]
    oms     = ["10.200.0.0/24"]
  }

}

resource "azurerm_firewall_policy_rule_collection_group" "sdgmapp_rule" {
  name               = "sdgmapp-fwpolicy-rcg"
  firewall_policy_id = module.firewall.policy_id
  priority           = 500

  application_rule_collection {
    name     = "aksfwar"
    priority = 500
    action   = "Allow"

    rule {
      name                  = "fqdn"
      destination_fqdn_tags = ["AzureKubernetesService"]
      source_addresses      = [local.uat.aks_subnet]
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
    }

    rule {
      name = "docker"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = [local.uat.aks_subnet]
      destination_fqdns = ["*.docker.io", "*.cloudflare.docker.com", "*.azurecr.io", "*.gcr.io", "storage.googleapis.com"]
    }

    rule {
      name = "azure-kv"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = [local.uat.aks_subnet]
      destination_fqdns = ["*.azure.net", "*.public-trust.com", "*.microsoftonline.com", "*.microsoft.com"]
    }

  }

  application_rule_collection {
    name     = "appfwar"
    priority = 510
    action   = "Allow"

    rule {
      name = "akeneo"
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = [local.uat.aks_subnet]
      destination_fqdns = ["*.akeneo.com"]
    }

  }

  network_rule_collection {
    name     = "aksfwnr"
    priority = 400
    action   = "Allow"

    rule {
      name                  = "apiudp"
      protocols             = ["UDP"]
      source_addresses      = [local.uat.aks_subnet]
      destination_addresses = ["*"]
      destination_ports     = ["1194"]
    }

    rule {
      name                  = "apitcp"
      protocols             = ["TCP"]
      source_addresses      = [local.uat.aks_subnet]
      destination_addresses = ["*"]
      destination_ports     = ["9000"]
    }

    rule {
      name              = "rime"
      protocols         = ["TCP"]
      source_addresses  = ["*"]
      destination_fqdns = ["ntp.ubuntu.com"]
      destination_ports = ["123"]
    }
  }

  network_rule_collection {
    name     = "bastionfwnr"
    priority = 410
    action   = "Allow"

    rule {
      name                  = "bastionSSH"
      protocols             = ["TCP", "UDP", "ICMP"]
      source_addresses      = local.vpn.peering
      destination_addresses = [local.nethub.bastion_snet]
      destination_ports     = ["22"]
    }
    rule {
      name                  = "bastionOmsSSH"
      protocols             = ["TCP", "UDP", "ICMP"]
      source_addresses      = local.vpn.oms
      destination_addresses = [local.nethub.bastion_snet]
      destination_ports     = ["22"]
    }
    rule {
      name                  = "bastionInternet"
      protocols             = ["TCP", "UDP", "ICMP"]
      source_addresses      = [local.nethub.bastion_snet]
      destination_addresses = ["0.0.0.0/0"]
      destination_ports     = ["*"]
    }
  }

  network_rule_collection {
    name     = "appfwnr"
    priority = 420
    action   = "Allow"
    rule {
      name                  = "apigw"
      protocols             = ["TCP", "UDP", "ICMP"]
      source_addresses      = [local.nethub.appgw_snet, local.nethub.private_agw_snet]
      destination_addresses = [local.uat.akslb_subnet]
      destination_ports     = ["80"]
    }
    rule {
      name                  = "public"
      protocols             = ["TCP", "UDP", "ICMP"]
      source_addresses      = [local.nethub.firewall_snet]
      destination_addresses = [local.uat.akslb_subnet]
      destination_ports     = ["80"]
    }
    rule {
      name                  = "private"
      protocols             = ["TCP", "UDP", "ICMP"]
      source_addresses      = local.vpn.peering
      destination_addresses = [local.nethub.private_agw_snet]
      destination_ports     = ["80", "443"]
    }
  }




  # nat_rule_collection {
  #   name     = "nat_rule_collection1"
  #   priority = 300
  #   action   = "Dnat"
  # rule {
  #   name                = "nat_rule_collection1_rule1"
  #   protocols           = ["TCP", "UDP"]
  #   source_addresses    = ["10.0.0.1", "10.0.0.2"]
  #   destination_address = "192.168.1.1"
  #   destination_ports   = ["80", "1000-2000"]
  #   translated_address  = "192.168.0.1"
  #   translated_port     = "8080"
  # }
  # }

  depends_on = [
    module.firewall
  ]
}
