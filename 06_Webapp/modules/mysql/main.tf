resource "azurerm_mysql_server" "mysql-server" {
  name                = "mysqlserver-${var.rg_name}"
  location            = var.location
  resource_group_name = var.rg_name

  administrator_login          = "mysqladmin"
  administrator_login_password = "LetMeIn!"

  sku_name   = "B_Gen5_2"
  storage_mb = 5120
  version    = "5.7"

  auto_grow_enabled                 = false
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = false
}

resource "azurerm_mysql_database" "database" {
  # ??
}

