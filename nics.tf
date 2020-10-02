
# Create the public IP address
resource "azurerm_public_ip" "pip" {
  count               = var.specs[terraform.workspace]["instance_count"]
  name                = "pip-${count.index}-mgmt"
  location            = azurerm_resource_group.azmain.location
  resource_group_name = azurerm_resource_group.azmain.name
  allocation_method   = "Static"   # Static is required due to the use of the Standard sku
  sku                 = "Standard" # the Standard sku is required due to the use of availability zones
  domain_name_label   = "${var.specs[terraform.workspace]["fqdn_name"]}${count.index}"
  #domain_name_label   = var.specs[terraform.workspace]["fqdn_name"]
  zones               = [element(local.azs, count.index)]
}

resource "azurerm_public_ip" "untrust_pip" {
  depends_on          = [azurerm_virtual_network.virtual_net]
  count               = var.specs[terraform.workspace]["instance_count"]
  name                = "pip-${count.index}-Untrust"
  location            = azurerm_resource_group.azmain.location
  resource_group_name = azurerm_resource_group.azmain.name
  allocation_method   = "Static"   # Static is required due to the use of the Standard sku
  sku                 = "Standard" # the Standard sku is required due to the use of availability zones
  zones               = [element(local.azs, count.index)]
}
resource "azurerm_public_ip" "untrust_pip_sec" {
  depends_on          = [azurerm_virtual_network.virtual_net]
  count               = var.specs[terraform.workspace]["instance_count"]
  name                = "pip-${count.index}-Untrust_sec"
  location            = azurerm_resource_group.azmain.location
  resource_group_name = azurerm_resource_group.azmain.name
  allocation_method   = "Static"   # Static is required due to the use of the Standard sku
  sku                 = "Standard" # the Standard sku is required due to the use of availability zones
  zones               = [element(local.azs, count.index)]
}

data "azurerm_public_ip" "untrust_pip_sec" {
  count               = var.specs[terraform.workspace]["instance_count"]
  depends_on          = [azurerm_virtual_network.virtual_net]
  name                = azurerm_public_ip.untrust_pip_sec[count.index].name
  resource_group_name = azurerm_linux_virtual_machine.virtualmachine[count.index].resource_group_name
  zones               = [element(local.azs, count.index)]
}

# data "azurerm_network_interface" "Untrust" {
#   count               = var.specs[terraform.workspace]["instance_count"]
#   depends_on          = [azurerm_virtual_network.virtual_net]
#   name                = azurerm_network_interface.Untrust[count.index].name
#   resource_group_name = azurerm_linux_virtual_machine.virtualmachine[count.index].resource_group_name
#   zones               = [element(local.azs, count.index)]
# }


#
# Create the network interfaces
resource "azurerm_network_interface" "Management" {
  depends_on           = [azurerm_virtual_network.virtual_net]
  count               = var.specs[terraform.workspace]["instance_count"]
  name                = "nic-${count.index}-mgmt"
  location            = azurerm_resource_group.azmain.location
  resource_group_name = azurerm_resource_group.azmain.name

  ip_configuration {
    name                          = "mgmt-${count.index}-ip-0"
    subnet_id                     = azurerm_subnet.Management[count.index % length(local.azs)].id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = element(azurerm_public_ip.pip.*.id, count.index)
    primary                       = "true"
  }
}

# Create the network interfaces
resource "azurerm_network_interface" "Untrust" {
  depends_on           = [azurerm_virtual_network.virtual_net]
  count                = var.specs[terraform.workspace]["instance_count"]
  name                 = "nic-${count.index}-untrust"
  location             = azurerm_resource_group.azmain.location
  resource_group_name  = azurerm_resource_group.azmain.name
  enable_ip_forwarding = true
  # this option enable_accelerated_networking will only work with specific Images version. DS4 is one of them
  enable_accelerated_networking = true

  ip_configuration {
    name                          = "untrust-${count.index}-ip-0"
    subnet_id                     = azurerm_subnet.Untrust[count.index % length(local.azs)].id
    private_ip_address_allocation = "dynamic"
    #private_ip_address_allocation = "Static"
    #private_ip_address            = var.specs[terraform.workspace]["static_ip"][1]
    #private_ip_address            = var.specs[terraform.workspace]["static_ip"]
    public_ip_address_id          = azurerm_public_ip.untrust_pip[count.index].id
    primary                       = true
  }
  ip_configuration {
    name                          = "untrust-${count.index}-ip-1"
    subnet_id                     = azurerm_subnet.Untrust[count.index % length(local.azs)].id
    private_ip_address_allocation = "dynamic"
    #private_ip_address_allocation = "Static"
    # private_ip_address            = var.specs[terraform.workspace]["static_sec_ip"][1]
    #private_ip_address            = var.specs[terraform.workspace]["static_sec_ip"]
    public_ip_address_id          = azurerm_public_ip.untrust_pip_sec[count.index].id
  }
}


# Create the network interfaces
resource "azurerm_network_interface" "Trust" {
  depends_on                    = [azurerm_virtual_network.virtual_net]
  count                         = var.specs[terraform.workspace]["instance_count"] 
  name                          = "nic-${count.index}-trust"
  location                      = azurerm_resource_group.azmain.location
  resource_group_name           = azurerm_resource_group.azmain.name
  enable_ip_forwarding          = true
  enable_accelerated_networking = true

  ip_configuration {
    name                          = "nic-${count.index}-ip-0"
    subnet_id                     = azurerm_subnet.Trust[count.index % length(local.azs)].id
    private_ip_address_allocation = "dynamic"
    #  private_ip_address            = var.specs[terraform.workspace]["static_ip"][0]
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "jointogether_networks" {
  count                     = var.specs[terraform.workspace]["instance_count"]
  network_interface_id      = element(azurerm_network_interface.Management.*.id, count.index)
  network_security_group_id = element(azurerm_network_security_group.security_gr.*.id, count.index)
}

# Untrust Network
resource "azurerm_network_interface_security_group_association" "Untrust-security" {
  count                     = var.specs[terraform.workspace]["instance_count"]
  network_interface_id      = azurerm_network_interface.Untrust[count.index].id
  network_security_group_id = azurerm_network_security_group.application_sg[count.index].id
}
