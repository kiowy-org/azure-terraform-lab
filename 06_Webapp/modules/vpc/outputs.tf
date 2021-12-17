data "azurerm_public_ip" "pip_data" {
  name                = azurerm_public_ip.pip.name
  resource_group_name = var.rg_name
}

output "public_ip_address" {
  value = data.azurerm_public_ip.pip_data.ip_address
}

data "azurerm_subnet" "internal_data" {
  name                  = azurerm_subnet.internal.id
  virtual_network_name  = azurerm_virtual_network.vpc.name 
  resource_group_name   = var.rg_name
}

output "internal_subnet_id" {
  value = data.azurerm_subnet.internal_data.id
}