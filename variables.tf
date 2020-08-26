variable "azurerm_instances" {
  default = "1"
}
variable "uname" {
  default = "remo"
}
variable "prefix" {
  default = "msdemo"
}
variable "network_name" {
  default = "bigip_network"
}
#search domain
variable "searchdomain" {
  default = "f5.com"
}
#Default Azure DNS
variable "dnsresolvers" {
  default = "168.63.129.16"
}
variable "bigiq_ipaddress" {
  default = "52.183.125.34"
}
# variable "bigiq_ipaddress" {
#   default = "23.102.174.99"
# }
variable "bigiq_user" {
  default = "admin"
}
# this variable is set in terraform.tfvars
variable "bigiq_pass" {
}
variable "hypervisor_type" {
  default = "azure"
}
variable "lic_pool" {
  default = "MSP-LOADv4-LIC"
}
# Secondary IP awareness
# If you are using the Azure LB and have DSR enabled on the load balancing rule (on the ALB), then all you need is a primary IP on the untrust...there is no need for secondary IP address.

variable "specs" {
  default = {
    default = {
      location      = "westus"
      name_rg       = "msft_demo_westus_bigip_rg"
      instance_type = "Standard_DS5_v2"
      environment   = "This env is using BIG-IP"
      owner         = "Remo Mattei"
      f5version     = "15.1.004000" # "14.1.203001"
      location      = "westus2"
      name_rg       = "main_bigip_rg"
      instance_type = "Standard_DS4_v2"
      environment   = "This env is using BIG-IP"
      owner         = "Remo Mattei"
      f5version     = "15.1.004000"
      plan_name     = "f5-big-ltm-2slot-byol"
      offer         = "f5-big-ip-byol"
      product       = "f5-big-ip-byol"
      publisher     = "f5-networks"
      sku           = "f5-big-ltm-2slot-byol"
      skukey1       = "LTM"
      skukey2       = "10G"
      unitofMeasure = "yearly"
      storage_type  = "Premium_LRS"
      virtualnet    = ["10.0.0.0/16"]
      trust         = ["10.0.10.0/24"]
      untrust       = ["10.0.20.0/24"]
      mgmt          = ["10.0.40.0/24"]
      comp_name     = "bigip15-msdemo.f5.com"
      default_gw    = "10.0.20.1"
      static_ip     = ["10.0.10.4", "10.0.20.4", "10.0.40.5"]
      static_sec_ip = ["10.0.10.5", "10.0.20.5", "10.0.40.6"]
      uname         = "azureuser"
    }
    europe = {
      location      = "westeurope"
      name_rg       = "westeurope_rg"
      instance_type = "Standard_DS3_v2"
      environment   = "This env is using BIG-IP"
      owner         = "Remo Mattei"
      f5version     = "15.1.004000"
      plan_name     = "f5-big-ltm-1slot-byol"
      offer         = "f5-big-ip-byol"
      product       = "f5-big-ip-byol"
      publisher     = "f5-networks"
      sku           = "f5-big-ltm-1slot-byol"
      skukey1       = "LTM"
      skukey2       = "5G"
      unitofMeasure = "yearly"
      storage_type  = "Premium_LRS"
      virtualnet    = ["10.0.0.0/16"]
      trust         = ["10.0.40.0/24"]
      untrust       = ["10.0.50.0/24"]
      mgmt          = ["10.0.60.0/24"]
      default_gw    = "10.0.50.1"
      comp_name     = "mybigip-msdemo.f5.com"
      static_ip     = ["10.0.40.4", "10.0.50.4", "10.0.60.5"]
      static_sec_ip = ["10.0.40.5", "10.0.50.5", "10.0.60.6"]
      uname         = "azureuser"
    }
    west = {
      location      = "southcentralus"
      name_rg       = "rm_southcentral_bigip_rg"
      instance_type = "Standard_DS4_v2"
      environment   = "This env is using BIG-IP"
      owner         = "Remo Mattei"
      f5version     = "15.1.004000"
      plan_name     = "f5-big-ltm-1slot-byol"
      offer         = "f5-big-ip-byol"
      product       = "f5-big-ip-byol"
      publisher     = "f5-networks"
      sku           = "f5-big-ltm-1slot-byol"
      skukey1       = "LTM"
      skukey2       = "10G"
      unitofMeasure = "yearly"
      storage_type  = "Premium_LRS"
      virtualnet    = ["10.0.0.0/8"]
      trust         = ["10.0.110.0/24"]
      untrust       = ["10.0.120.0/24"]
      mgmt          = ["10.0.130.0/24"]
      default_gw    = "10.0.120.1"
      comp_name     = "mybigip.f5.com"
      static_ip     = ["10.0.110.4", "10.0.120.4", "10.0.130.5"]
      static_sec_ip = ["10.0.110.5", "10.0.120.5", "10.0.130.6"]
      uname         = "azureuser"
    }
    central = {
      location      = "southcentralus"
      name_rg       = "msdemo_centralus_rg"
      instance_type = "Standard_DS3_v2"
      environment   = "This env is using BIG-IP"
      owner         = "Remo Mattei"
      f5version     = "15.1.004000"
      plan_name     = "f5-big-ltm-1slot-byol"
      offer         = "f5-big-ip-byol"
      product       = "f5-big-ip-byol"
      publisher     = "f5-networks"
      sku           = "f5-big-ltm-1slot-byol"
      skukey1       = "LTM"
      skukey2       = "5G"
      unitofMeasure = "yearly"
      storage_type  = "Premium_LRS"
      virtualnet    = ["10.0.0.0/8"]
      trust         = ["10.0.1.0/24"]
      untrust       = ["10.0.2.0/24"]
      mgmt          = ["10.0.3.0/24"]
      default_gw    = "10.0.2.1"
      comp_name     = "msdemo.f5.com"
      static_ip     = ["10.0.1.4", "10.0.2.4", "10.0.3.5"]
      static_sec_ip = ["10.0.1.5", "10.0.2.5", "10.0.3.6"]
      uname         = "azureuser"
    }
  }
}

## Please check and update the latest DO URL from https://github.com/F5Networks/f5-declarative-onboarding/releases
# always point to a specific version in order to avoid inadvertent configuration inconsistency
variable DO_URL {
  description = "URL to download the BIG-IP Declarative Onboarding module"
  default     = "https://github.com/F5Networks/f5-declarative-onboarding/releases/download/v1.14.0/f5-declarative-onboarding-1.14.0-1.noarch.rpm"
  #default     = "https://github.com/F5Networks/f5-declarative-onboarding/releases/download/v1.13.0/f5-declarative-onboarding-1.13.0-5.noarch.rpm"
  #default    = "https://github.com/F5Networks/f5-declarative-onboarding/releases/download/v1.12.0/f5-declarative-onboarding-1.12.0-1.noarch.rpm"
  #default    = "https://github.com/F5Networks/f5-declarative-onboarding/releases/download/v1.9.0/f5-declarative-onboarding-1.9.0-1.noarch.rpm"
}
## Please check and update the latest AS3 URL from https://github.com/F5Networks/f5-appsvcs-extension/releases/latest
# always point to a specific version in order to avoid inadvertent configuration inconsistency
variable AS3_URL {
  description = "URL to download the BIG-IP Application Service Extension 3 (AS3) module"
  default     = "https://github.com/F5Networks/f5-appsvcs-extension/releases/download/v3.21.0/f5-appsvcs-3.21.0-4.noarch.rpm"
  #default    = "https://github.com/F5Networks/f5-appsvcs-extension/releases/download/v3.20.0/f5-appsvcs-3.20.0-3.noarch.rpm"
  #default    = "https://github.com/F5Networks/f5-appsvcs-extension/releases/download/v3.19.1/f5-appsvcs-3.19.1-1.noarch.rpm"
  # default   = "https://github.com/F5Networks/f5-appsvcs-extension/releases/download/v3.19.0/f5-appsvcs-3.19.0-4.noarch.rpm"
  #default    = "https://github.com/F5Networks/f5-appsvcs-extension/releases/download/v3.16.0/f5-appsvcs-3.16.0-6.noarch.rpm"
}
## Please check and update the latest TS URL from https://github.com/F5Networks/f5-telemetry-streaming/releases/latest
# always point to a specific version in order to avoid inadvertent configuration inconsistency
variable TS_URL {
  description = "URL to download the BIG-IP Telemetry Streaming Extension (TS) module"
  default     = "https://github.com/F5Networks/f5-telemetry-streaming/releases/download/v1.13.0/f5-telemetry-1.13.0-2.noarch.rpm"
  #default     = "https://github.com/F5Networks/f5-telemetry-streaming/releases/download/v1.12.0/f5-telemetry-1.12.0-3.noarch.rpm"
  #default    = "https://github.com/F5Networks/f5-telemetry-streaming/releases/download/v1.11.0/f5-telemetry-1.11.0-1.noarch.rpm"
  #default    = "https://github.com/F5Networks/f5-telemetry-streaming/releases/download/v1.8.0/f5-telemetry-1.8.0-1.noarch.rpm"
}
variable "FAST_URL" {
  description = "F5 Application Services Templates (FAST) are an easy and effective way to deploy applications on the BIG-IP system using AS3."
  default     = "https://github.com/F5Networks/f5-appsvcs-templates/releases/download/v1.2.0/f5-appsvcs-templates-1.2.0-1.noarch.rpm"
  #default    = "https://github.com/F5Networks/f5-appsvcs-templates/releases/download/v1.1.0/f5-appsvcs-templates-1.1.0-1.noarch.rpm"
  #default    = "https://github.com/F5Networks/f5-appsvcs-templates/releases/download/v1.0.0/f5-appsvcs-templates-1.0.0-1.noarch.rpm"
}

variable onboard_log {
  description = "Directory on the BIG-IP to store the cloud-init logs"
  default     = "/var/log/startup-script.log"
}
