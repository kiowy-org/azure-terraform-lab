output "network_interface_private_ip" {
  value = azurerm_public_ip.apache_server_pip.*.ip_address
}