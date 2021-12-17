output "public_ip_address" {
  value = azurerm_public_ip.pip.ip_address
}

output "internal_subnet_id" {
  value = azurerm_subnet.internal.id
}