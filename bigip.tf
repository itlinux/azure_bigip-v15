# Create the virtual machine. Use the "count" variable to define how many
# to create.
resource "azurerm_linux_virtual_machine" "virtualmachine" {
  count                           = var.specs[terraform.workspace]["instance_count"]
  name                            = title("${var.prefix}_machine_num_${count.index + 1}")
  admin_username                  = var.specs[terraform.workspace]["uname"]
  admin_password                  = random_password.dpasswrd.result
  computer_name                   = title("${var.specs[terraform.workspace]["comp_name"]}-${count.index + 1}")
  location                        = azurerm_resource_group.azmain.location
  resource_group_name             = azurerm_resource_group.azmain.name
  size                            = var.specs[terraform.workspace]["instance_type"]
  zone                            = element(local.azs, count.index % length(local.azs))
  disable_password_authentication = false
  custom_data                     = base64encode(data.template_file.vm_onboard[count.index].rendered)
  depends_on                      = [azurerm_virtual_network.virtual_net, azurerm_public_ip.pip]
  network_interface_ids = [
    element(azurerm_network_interface.Management.*.id, count.index),
    element(azurerm_network_interface.Untrust.*.id, count.index),
    element(azurerm_network_interface.Trust.*.id, count.index),
  ]

  # F5 resources
  source_image_reference {
    publisher = var.specs[terraform.workspace]["publisher"]
    offer     = var.specs[terraform.workspace]["offer"]
    sku       = var.specs[terraform.workspace]["sku"]
    version   = var.specs[terraform.workspace]["f5version"]
  }

  plan {
    name      = var.specs[terraform.workspace]["plan_name"]
    product   = var.specs[terraform.workspace]["product"]
    publisher = var.specs[terraform.workspace]["publisher"]
  }

  #Disk
  os_disk {
    name                 = "${var.prefix}-osdisk-${count.index}"
    storage_account_type = var.specs[terraform.workspace]["storage_type"]
    caching              = "ReadWrite"
    disk_size_gb         = "100"
  }
}

### Setup Onboarding scripts
data "template_file" "vm_onboard" {
  depends_on = [azurerm_network_interface.Untrust, azurerm_network_interface.Trust]
  count      = var.specs[terraform.workspace]["instance_count"]
  template   = "${file("${path.module}/onboard.yml")}"
  vars = {
    DO_URL                      = var.DO_URL
    AS3_URL                     = var.AS3_URL
    TS_URL                      = var.TS_URL
    FAST_URL                    = var.FAST_URL
    onboard_log                 = var.onboard_log
    bigip_hostname              = "${var.specs[terraform.workspace]["fqdn_name"]}${count.index}.${var.specs[terraform.workspace]["d_name"]}"
    bigiq_license_host          = var.bigiq_ipaddress
    bigiq_license_username      = var.bigiq_user
    bigiq_license_password      = var.bigiq_pass
    bigiq_license_licensepool   = var.lic_pool
    bigiq_license_skuKeyword1   = var.specs[terraform.workspace]["skukey1"]
    bigiq_license_skuKeyword2   = var.specs[terraform.workspace]["skukey2"]
    bigiq_license_unitOfMeasure = var.specs[terraform.workspace]["unitofMeasure"]
    bigiq_hypervisor            = var.hypervisor_type
    name_servers                = var.dnsresolvers
    search_domain               = var.searchdomain
    default_gw                  = cidrhost(azurerm_subnet.Untrust[count.index % length(local.azs)].address_prefix, 1)
    external_ip                 = azurerm_network_interface.Untrust[count.index].private_ip_address
    internal_ip                 = azurerm_network_interface.Trust[count.index].private_ip_address
    bigipuser                   = var.specs[terraform.workspace]["uname"]
    bigippass                   = random_password.dpasswrd.result
    region                      = var.specs[terraform.workspace]["location"]
  }
}
data "template_file" "ansible_info" {
  depends_on = [azurerm_linux_virtual_machine.virtualmachine]
  count      = var.specs[terraform.workspace]["instance_count"]
  template   = file("./ansible/bigip.txt")
  vars = {
    mgmt     = azurerm_linux_virtual_machine.virtualmachine[count.index].public_ip_address,
    username = var.specs[terraform.workspace]["uname"]
    pwd      = random_password.dpasswrd.result
    priv_ip  = azurerm_network_interface.Untrust[count.index].ip_configuration[1].private_ip_address
  }
}

resource "local_file" "creds_playbook" {
  count    = var.specs[terraform.workspace]["instance_count"]
  content  = data.template_file.ansible_info[count.index].rendered
  filename = "./ansible/creds${count.index}.yml"
}

# data "template_file" "ansible_creds" {
#   depends_on = [azurerm_linux_virtual_machine.virtualmachine]
#   count      = var.specs[terraform.workspace]["instance_count"]
#   template   = file("./ansible/.txt")
#   vars = {
#     creds = data.template_file.ansible_info[count.index].rendered
#   }
# }


resource "local_file" "creds_file" {
  count    = var.specs[terraform.workspace]["instance_count"]
  content  = data.template_file.ansible_info[count.index].rendered
  filename = "./ansible/creds${count.index}.yml"
}
