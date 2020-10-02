output mgmt_IP_address {
  value = azurerm_linux_virtual_machine.virtualmachine[*].public_ip_address
}
output Genereated_Password {
  value = random_password.dpasswrd.result
}
output Secondary_Untrust_IPs {
  value = data.azurerm_public_ip.untrust_pip_sec.*.ip_address
}
output mgmt_fqdn {
  value = azurerm_public_ip.pip.*.fqdn
}
