locals {
  cidr = var.specs[terraform.workspace]["virtualnet"]
}

#
resource "azurerm_virtual_network" "virtual_net" {
  name                = format("%s-vnet-%s", var.prefix, random_id.randomId.hex)
  address_space       = [local.cidr]
  location            = var.specs[terraform.workspace]["location"]
  resource_group_name = azurerm_resource_group.azmain.name
}

# Create management subnet
resource "azurerm_subnet" "Management" {
  count                = var.specs[terraform.workspace]["instance_count"]
  name                 = format("%s-managementsubnet-%s-%s", var.prefix, count.index, random_id.randomId.hex)
  resource_group_name  = azurerm_resource_group.azmain.name
  virtual_network_name = azurerm_virtual_network.virtual_net.name
  # address prefix 10.1x.0.0/24
  address_prefixes = [cidrsubnet(cidrsubnet(local.cidr, 8, 10 + count.index), 8, 0)]
}
# Create public/external subnet
resource "azurerm_subnet" "Untrust" {
  count                = var.specs[terraform.workspace]["instance_count"]
  name                 = format("%s-Untrustsubnet-%s-%s", var.prefix, count.index, random_id.randomId.hex)
  resource_group_name  = azurerm_resource_group.azmain.name
  virtual_network_name = azurerm_virtual_network.virtual_net.name
  # address prefix 10.2x.0.0/24
  address_prefixes = [cidrsubnet(cidrsubnet(local.cidr, 8, 20 + count.index), 8, 0)]
}
# Create private/internal subnet
resource "azurerm_subnet" "Trust" {
  count                = var.specs[terraform.workspace]["instance_count"]
  name                 = format("%s-Trustsubnet-%s-%s", var.prefix, count.index, random_id.randomId.hex)
  resource_group_name  = azurerm_resource_group.azmain.name
  virtual_network_name = azurerm_virtual_network.virtual_net.name
  # address prefix 10.3x.0.0/24
  address_prefixes = [cidrsubnet(cidrsubnet(local.cidr, 8, 30 + count.index), 8, 0)]
}
