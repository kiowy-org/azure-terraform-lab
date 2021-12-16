# scale up alarm
resource "azurerm_monitor_autoscale_setting" "" {
    # cpu metric config to scale up
    rule {
      metric_trigger {
      }

      scale_action {
      }
    }

    # cpu metric config to scale down
    rule {
      metric_trigger {
      }

      scale_action {
      }
    }
}