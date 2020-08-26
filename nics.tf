
# Create the public IP address
resource "azurerm_public_ip" "pip" {
  count               = var.azurerm_instances
  name                = "pip-${count.index}-mgmt"
  location            = azurerm_resource_group.azmain.location
  resource_group_name = azurerm_resource_group.azmain.name
  allocation_method   = "Dynamic"
}

resource "azurerm_public_ip" "untrust_pip" {
  depends_on          = [azurerm_virtual_network.virtual_net]
  count               = var.azurerm_instances
  name                = "pip-${count.index}-Untrust"
  location            = azurerm_resource_group.azmain.location
  resource_group_name = azurerm_resource_group.azmain.name
  allocation_method   = "Dynamic"
}
resource "azurerm_public_ip" "untrust_pip_sec" {
  depends_on          = [azurerm_virtual_network.virtual_net]
  count               = var.azurerm_instances
  name                = "pip-${count.index}-Untrust_sec"
  location            = azurerm_resource_group.azmain.location
  resource_group_name = azurerm_resource_group.azmain.name
  allocation_method   = "Dynamic"
}

data "azurerm_public_ip" "untrust_pip_sec" {
  depends_on          = [azurerm_virtual_network.virtual_net]
  name                = azurerm_public_ip.untrust_pip_sec[0].name
  resource_group_name = azurerm_linux_virtual_machine.virtualmachine[0].resource_group_name
}

# Create the network interfaces
resource "azurerm_network_interface" "Management" {
  depends_on          = [azurerm_subnet.Mgmt]
  count               = var.azurerm_instances
  name                = "nic-${count.index}-mgmt"
  location            = azurerm_resource_group.azmain.location
  resource_group_name = azurerm_resource_group.azmain.name

  ip_configuration {
    name                          = "mgmt-${count.index}-ip-0"
    subnet_id                     = azurerm_subnet.Mgmt.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = element(azurerm_public_ip.pip.*.id, count.index)
    primary                       = "true"
  }
}

# Create the network interfaces
resource "azurerm_network_interface" "Untrust" {
  depends_on           = [azurerm_subnet.Untrust]
  count                = var.azurerm_instances
  name                 = "nic-${count.index}-untrust"
  location             = azurerm_resource_group.azmain.location
  resource_group_name  = azurerm_resource_group.azmain.name
  enable_ip_forwarding = true
# this option enable_accelerated_networking will only work with specific Images version. DS4 is one of them
  enable_accelerated_networking = true

  ip_configuration {
    name                          = "untrust-${count.index}-ip-0"
    subnet_id                     = azurerm_subnet.Untrust.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.specs[terraform.workspace]["static_ip"][1]
    public_ip_address_id          = azurerm_public_ip.untrust_pip[count.index].id
    primary                       = true
  }
  ip_configuration {
    name                          = "untrust-${count.index}-ip-1"
    subnet_id                     = azurerm_subnet.Untrust.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.specs[terraform.workspace]["static_sec_ip"][1]
    public_ip_address_id          = azurerm_public_ip.untrust_pip_sec[count.index].id
  }
}


# Create the network interfaces
resource "azurerm_network_interface" "Trust" {
  depends_on           = [azurerm_subnet.Trust]
  count                = var.azurerm_instances
  name                 = "nic-${count.index}-trust"
  location             = azurerm_resource_group.azmain.location
  resource_group_name  = azurerm_resource_group.azmain.name
  enable_ip_forwarding = true
  enable_accelerated_networking = true

  ip_configuration {
    name                          = "nic-${count.index}-ip-0"
    subnet_id                     = azurerm_subnet.Trust.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.specs[terraform.workspace]["static_ip"][0]
  }
}
# Create the availability set
# resource "azurerm_availability_set" "az-zone" {
#   name                = "az-zone"
#   location            = azurerm_resource_group.azmain.location
#   resource_group_name = azurerm_resource_group.azmain.name
#platform_update_domain_count = "2"
#platform_fault_domain_count  = "1"
#}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "jointogether_networks" {
  count                     = var.azurerm_instances
  network_interface_id      = element(azurerm_network_interface.Management.*.id, count.index)
  network_security_group_id = element(azurerm_network_security_group.security_gr.*.id, count.index)
}

# Untrust Network
resource "azurerm_network_interface_security_group_association" "Untrust-security" {
  count                     = var.azurerm_instances
  network_interface_id      = azurerm_network_interface.Untrust[count.index].id
  network_security_group_id = azurerm_network_security_group.application_sg.id
}
