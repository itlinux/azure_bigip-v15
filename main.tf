terraform {
  required_version = "> 0.12.0"
}

provider "azurerm" {
  # The "feature" block is required for AzureRM provider 2.x.
  # If you are using version 1.x, the "features" block is not allowed.
  version = "~>2.0"
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "azmain" {
  name     = var.specs[terraform.workspace]["name_rg"]
  location = var.specs[terraform.workspace]["location"]
  tags = {
    environment = var.specs[terraform.workspace]["environment"]
    owner       = var.specs[terraform.workspace]["owner"]
  }
}
