locals {
  cidr = var.specs[terraform.workspace]["virtualnet"]
  #base_cidr_block = "var.specs[terraform.workspace]["virtualnet"]"
}

#
resource "azurerm_virtual_network" "virtual_net" {
    name                = format("%s-vnet-%s",var.prefix,random_id.randomId.hex)
    address_space       = [local.cidr]
    location            = var.specs[terraform.workspace]["location"]
    resource_group_name = azurerm_resource_group.azmain.name
}

# Create management subnet
resource "azurerm_subnet" "Management" {
    count                = length(local.azs)
    name                 = format("%s-managementsubnet-%s-%s",var.prefix,count.index,random_id.randomId.hex)
    resource_group_name  = azurerm_resource_group.azmain.name
    virtual_network_name = azurerm_virtual_network.virtual_net.name
    # address prefix 10.1x.0.0/24
    address_prefixes       = [cidrsubnet(cidrsubnet(local.cidr, 8, 10 + count.index),8,0)]
}
# Create public/external subnet
resource "azurerm_subnet" "Untrust" {
    count                = length(local.azs)
    name                 = format("%s-Untrustsubnet-%s-%s",var.prefix,count.index,random_id.randomId.hex)
    resource_group_name  = azurerm_resource_group.azmain.name
    virtual_network_name = azurerm_virtual_network.virtual_net.name
    # address prefix 10.2x.0.0/24
    address_prefixes     = [cidrsubnet(cidrsubnet(local.cidr, 8, 20 + count.index),8,0)]
}
# Create private/internal subnet
resource "azurerm_subnet" "Trust" {
    count                = length(local.azs)
    name                 = format("%s-Trustsubnet-%s-%s",var.prefix,count.index,random_id.randomId.hex)
    resource_group_name  = azurerm_resource_group.azmain.name
    virtual_network_name = azurerm_virtual_network.virtual_net.name
    # address prefix 10.3x.0.0/24
    address_prefixes     = [cidrsubnet(cidrsubnet(local.cidr, 8, 30 + count.index),8,0)]
}

# Create a virtual network in the resource group
#resource "azurerm_virtual_network" "virtual_net" {
#  name                = "vnet-${var.network_name}"
#  address_space       = local.base_cidr_block
#  resource_group_name = azurerm_resource_group.azmain.name
#  location = var.specs[terraform.workspace]["location"]
#     dynamic "subnet" {
#       for_each = [for s in var.subnets : {
#         name  = "${each.key}-subnet"
#         prefix = cidrsubnet(local.base_cidr_block, 8, s.number)
#       }]
#       content {
#         name           = subnet.value.name
#         address_prefix = subnet.value.prefix
#       }
#     }
#   }
##address_space       = var.specs[terraform.workspace]["virtualnet"]

# resource "azurerm_subnet" "Mgmt" {
#   depends_on           = [azurerm_virtual_network.virtual_net]
#   name                 = "Mgmt"
#   resource_group_name  = azurerm_resource_group.azmain.name
#   virtual_network_name = azurerm_virtual_network.virtual_net.name
#   address_prefixes     = var.specs[terraform.workspace]["mgmt"]
# }

# resource "azurerm_subnet" "Untrust" {
#   depends_on           = [azurerm_virtual_network.virtual_net]
#   name                 = "Untrust"
#   resource_group_name  = azurerm_resource_group.azmain.name
#   virtual_network_name = azurerm_virtual_network.virtual_net.name
#   address_prefixes     = var.specs[terraform.workspace]["untrust"]
# }

# resource "azurerm_subnet" "Trust" {
#   depends_on           = [azurerm_virtual_network.virtual_net]
#   name                 = "Trust"
#   resource_group_name  = azurerm_resource_group.azmain.name
#   virtual_network_name = azurerm_virtual_network.virtual_net.name
#   address_prefixes     = var.specs[terraform.workspace]["trust"]
# }
