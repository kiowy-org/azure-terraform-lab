resource "azurerm_monitor_autoscale_setting" "autoscaler_setting" {
    name                = "autoscalerSettings"
    resource_group_name = var.rg_name
    location            = var.location
    

    # Bonne chance...
}