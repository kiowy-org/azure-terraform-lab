# Security group of the db
resource "azurerm_network_security_group" "db_sg" {

}

resource "azurerm_sql_server" "" {

}

# Subnets of the db
resource "azurerm_subnet" "mariadb-subnet" {
  
}

# Parameters of the db (mariadb)
resource "azurerm_storage_account" "mariadb-parameters" {

}

# Db instance
resource "azurerm_sql_database" "mariadb" {

}