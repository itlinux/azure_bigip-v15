# Create the virtual machine. Use the "count" variable to define how many
# to create.
resource "azurerm_linux_virtual_machine" "virtualmachine" {
  count                           = var.azurerm_instances
  name                            = title("${var.prefix}_machine_num_${count.index + 1}")
  admin_username                  = var.specs[terraform.workspace]["uname"]
  admin_password                  = random_password.dpasswrd.result
  computer_name                   = title("${var.specs[terraform.workspace]["comp_name"]}-${count.index + 1}")
  location                        = azurerm_resource_group.azmain.location
  resource_group_name             = azurerm_resource_group.azmain.name
  size                            = var.specs[terraform.workspace]["instance_type"]
  disable_password_authentication = false
  custom_data                     = base64encode(data.template_file.vm_onboard.rendered)
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
  }
}
# to te tested for removing BIG-IP from BIG-IQ
# provisioner "local-exec" {
#     when    = "destroy"
#     interpreter = ["/bin/bash", "-c"]
#     command = <<-EOF
#     token=$(curl -k -X POST https://bigiq_ipaddress}:443/mgmt/shared/authn/login \
#       -H "Content-Type: application/json" \

### Setup Onboarding scripts
data "template_file" "vm_onboard" {
  template = "${file("${path.module}/onboard.yml")}"
  vars = {
    DO_URL                      = var.DO_URL
    AS3_URL                     = var.AS3_URL
    TS_URL                      = var.TS_URL
    onboard_log                 = var.onboard_log
    bigip_hostname              = var.specs[terraform.workspace]["comp_name"]
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
    default_gw                  = var.specs[terraform.workspace]["default_gw"]
    external_ip                 = azurerm_network_interface.Untrust[0].private_ip_address
    internal_ip                 = azurerm_network_interface.Trust[0].private_ip_address
    bigipuser                   = var.specs[terraform.workspace]["uname"]
    bigippass                   = random_password.dpasswrd.result
  }
}
data "template_file" "ansible_info" {
  template = "${file("./ansible/bigip.txt")}"
  vars = {
    mgmt     = azurerm_linux_virtual_machine.virtualmachine[0].public_ip_address,
    username = var.specs[terraform.workspace]["uname"]
    pwd      = random_password.dpasswrd.result
  }
}

resource "local_file" "creds_playbook" {
  content  = data.template_file.ansible_info.rendered
  filename = "./ansible/creds.yml"
}