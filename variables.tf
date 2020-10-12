variable "azurerm_instances" {
  default = "1"
}
variable "uname" {
  default = "remo"
}
variable "prefix" {
  default = "rmdemoF5"
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
  default = "23.102.174.99"
}
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

variable "shared_key" {
}
variable "workspace-id" {
  default = "wester-log"
}

variable "workspace_id" {
}

## Secondary IP awareness
# If you are using the Azure LB and have DSR enabled on the load balancing rule (on the ALB), then all you need is a primary IP on the untrust...there is no need for secondary IP address.
# for the dynamic version only default variables are correct. I will need to update the other regions 
variable "specs" {
  default = {
    default = {
      location       = "westus 2"
      name_rg        = "westus2_remo_rg"
      instance_type  = "Standard_DS5_v2"
      environment    = "This env is using BIG-IP"
      owner          = "Remo Mattei"
      f5version      = "15.1.004000"
      plan_name      = "f5-big-all-2slot-byol"
      offer          = "f5-big-ip-byol"
      product        = "f5-big-ip-byol"
      publisher      = "f5-networks"
      sku            = "f5-big-all-2slot-byol"
      skukey1        = "LTM"
      instance_count = "3"
      skukey2        = "10G"
      unitofMeasure  = "yearly"
      storage_type   = "Premium_LRS"
      virtualnet     = "10.0.0.0/8"
      comp_name      = "westus2.cloudapp.azure.com"
      d_name         = "westus2.cloudapp.azure.com"
      uname          = "itlinux"
      fqdn_name      = "rmdemo"
      azs            = ["1", "3"]
    }
    europe = {
      location      = "westeurope"
      name_rg       = "westeurope_rg"
      instance_type = "Standard_DS3_v2"
      environment   = "This env is using BIG-IP"
      owner         = "Remo Mattei"
      f5version     = "15.1.004000"
      plan_name     = "f5-big-all-2slot-byol"
      offer         = "f5-big-ip-byol"
      product       = "f5-big-ip-byol"
      publisher     = "f5-networks"
      sku           = "f5-big-ltm-1slot-byol"
      skukey1       = "LTM"
      skukey2       = "5G"
      instance_count = "1"
      unitofMeasure = "yearly"
      storage_type  = "Premium_LRS"
      virtualnet    = ["10.0.0.0/16"]
      comp_name     = "westeurope.cloudapp.azure.com"
      d_name         = "westeurope.cloudapp.azure.com"
      uname          = "itlinux"
      fqdn_name      = "westdemo"
      azs            = ["1"]
}
    west = {
      location      = "southcentralus"
      name_rg       = "rm_southcentral_bigip_rg"
      instance_type = "Standard_DS4_v2"
      environment   = "This env is using BIG-IP"
      owner         = "Remo Mattei"
      f5version     = "15.1.004000"
      plan_name     = "f5-big-all-2slot-byol"
      offer         = "f5-big-ip-byol"
      product       = "f5-big-ip-byol"
      publisher     = "f5-networks"
      sku           = "f5-big-ltm-1slot-byol"
      skukey1       = "LTM"
      skukey2       = "10G"
      instance_count = "1"
      unitofMeasure = "yearly"
      unitofMeasure = "yearly"
      storage_type  = "Premium_LRS"
      virtualnet    = ["10.0.0.0/8"]
      comp_name     = "southcentral.cloudapp.azure.com"
      d_name         = "southcentral.cloudapp.azure.com"
      uname          = "itlinux"
      fqdn_name      = "southdemo"
      azs            = ["1"]
}
    central = {
      location      = "southcentralus"
      name_rg       = "remo_centralus_rg"
      instance_type = "Standard_DS5_v2"
      environment   = "This env is using BIG-IP"
      owner         = "Remo Mattei"
      f5version     = "15.1.004000"
      plan_name     = "f5-big-all-2slot-byol"
      offer         = "f5-big-ip-byol"
      product       = "f5-big-ip-byol"
      publisher     = "f5-networks"
      sku           = "f5-big-all-2slot-byol"
      skukey1       = "ASM"
      skukey2       = "3G"
      instance_count = "2"
      unitofMeasure = "yearly"
      unitofMeasure = "yearly"
      storage_type  = "Premium_LRS"
      virtualnet    = ["10.0.0.0/8"]
      comp_name     = "southcentralus.cloudapp.azure.com"
      d_name         = "southcentralus.cloudapp.azure.com"
      uname          = "itlinux"
      fqdn_name      = "southdemo"
      azs            = ["1", "2"]
    }
  }
}

## Please check and update the latest DO URL from https://github.com/F5Networks/f5-declarative-onboarding/releases
# always point to a specific version in order to avoid inadvertent configuration inconsistency
variable DO_URL {
  description = "URL to download the BIG-IP Declarative Onboarding module"
  default     = "https://github.com/F5Networks/f5-declarative-onboarding/releases/download/v1.15.0/f5-declarative-onboarding-1.15.0-3.noarch.rpm"
}
## Please check and update the latest AS3 URL from https://github.com/F5Networks/f5-appsvcs-extension/releases/latest
# always point to a specific version in order to avoid inadvertent configuration inconsistency
variable AS3_URL {
  description = "URL to download the BIG-IP Application Service Extension 3 (AS3) module"
  default     = "https://github.com/F5Networks/f5-appsvcs-extension/releases/download/v3.22.1/f5-appsvcs-3.22.1-1.noarch.rpm"
}
## Please check and update the latest TS URL from https://github.com/F5Networks/f5-telemetry-streaming/releases/latest
# always point to a specific version in order to avoid inadvertent configuration inconsistency
variable TS_URL {
  description = "URL to download the BIG-IP Telemetry Streaming Extension (TS) module"
  default     = "https://github.com/F5Networks/f5-telemetry-streaming/releases/download/v1.14.0/f5-telemetry-1.14.0-2.noarch.rpm"
}
variable "FAST_URL" {
  description = "F5 Application Services Templates (FAST) are an easy and effective way to deploy applications on the BIG-IP system using AS3."
  default     = "https://github.com/F5Networks/f5-appsvcs-templates/releases/download/v1.3.0/f5-appsvcs-templates-1.3.0-1.noarch.rpm"
}
variable onboard_log {
  description = "Directory on the BIG-IP to store the cloud-init logs"
  default     = "/var/log/startup-script.log"
}
