data "azurerm_public_ip" "pip_data" {
  name                = azurerm_public_ip.pip.name
  resource_group_name = azurerm_linux_virtual_machine.main_vm.resource_group_name
}

output "public_ip_address" {
  value = data.azurerm_public_ip.pip_data.ip_address
}