terraform {
  required_version = "> 0.12.29"
}

provider "azurerm" {
  # The "feature" block is required for AzureRM provider 2.x.
  # If you are using version 1.x, the "features" block is not allowed.
  features {}
}

# Create a resource group
data "azurerm_resource_group" "azmain" {
  name     = var.specs[terraform.workspace]["name_rg"]
  # tags = {
  #   environment = var.specs[terraform.workspace]["environment"]
  #   owner       = var.specs[terraform.workspace]["owner"]
  #}
}
  #name     = var.specs[terraform.workspace]["name_rg"]

