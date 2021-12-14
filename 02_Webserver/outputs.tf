output "network_interface_private_ip" {
  value = azurerm_network_interface.apache_server_nic.private_ip_address
}