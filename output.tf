output mgmt_IP_address {
  value = azurerm_linux_virtual_machine.virtualmachine[*].public_ip_address
}
output Genereated_Password {
  value = random_password.dpasswrd.result
}

output Untrusted_IPs {
  description = "Public IPs for the Untrust"
  value       = list(azurerm_public_ip.untrust_pip.*.ip_address, azurerm_public_ip.untrust_pip_sec.*.ip_address)
  depends_on  = [azurerm_virtual_network.virtual_net]
}
