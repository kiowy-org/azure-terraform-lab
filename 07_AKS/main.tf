resource "random_pet" "name" {
}
resource "azurerm_resource_group" "rg" {
  name = "${random_pet.name.id}-rg"
  location = "France Central"
}