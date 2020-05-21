# Create a virtual network in the resource group
resource "azurerm_virtual_network" "virtual_net" {
  name                = "vnet-${var.network_name}"
  address_space       = var.specs[terraform.workspace]["virtualnet"]
  location            = azurerm_resource_group.azmain.location
  resource_group_name = azurerm_resource_group.azmain.name
}

resource "azurerm_subnet" "Mgmt" {
  depends_on           = [azurerm_virtual_network.virtual_net]
  name                 = "Mgmt"
  resource_group_name  = azurerm_resource_group.azmain.name
  virtual_network_name = azurerm_virtual_network.virtual_net.name
  address_prefixes     = var.specs[terraform.workspace]["mgmt"]
}

resource "azurerm_subnet" "Untrust" {
  depends_on           = [azurerm_virtual_network.virtual_net]
  name                 = "Untrust"
  resource_group_name  = azurerm_resource_group.azmain.name
  virtual_network_name = azurerm_virtual_network.virtual_net.name
  address_prefixes     = var.specs[terraform.workspace]["untrust"]
}

resource "azurerm_subnet" "Trust" {
  depends_on           = [azurerm_virtual_network.virtual_net]
  name                 = "Trust"
  resource_group_name  = azurerm_resource_group.azmain.name
  virtual_network_name = azurerm_virtual_network.virtual_net.name
  address_prefixes     = var.specs[terraform.workspace]["trust"]
}
