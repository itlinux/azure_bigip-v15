output "Machine_PublicIP" {
  value = azurerm_linux_virtual_machine.virtualmachine.*.public_ip_address
}
output "Genereated_Password" {
  value = random_password.dpasswrd.result
}
