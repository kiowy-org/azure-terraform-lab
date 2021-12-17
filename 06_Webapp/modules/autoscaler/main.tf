resource "azurerm_monitor_autoscale_setting" "autoscaler_setting" {
    name                = "autoscalerSettings"
    resource_group_name = var.rg_name
    location            = var.location
    target_resource_id  = var.machine_id

    profile {
      name = "autoScaleProfile"

      capacity {
        default = 1
        minimum = 1
        maximum = 5
      }

      # cpu metric config to scale up
      rule {
        # scale up alarm
        metric_trigger {
          metric_name        = "Percentage CPU"
          metric_resource_id = var.machine_id
          time_grain         = "PT1M"
          statistic          = "Average"
          time_window        = "PT5M"
          time_aggregation   = "Average"
          operator           = "GreaterThan"
          threshold          = 75
          metric_namespace   = "microsoft.compute/linuxvirtualmachinescalesets"
                
          dimensions {
            name     = "AppName"
            operator = "Equals"
            values   = ["App1"]
          }
        }

        scale_action {
          direction = "Increase"
          type      = "ChangeCount"
          value     = "1"
          cooldown  = "PT1M"
        }
      }

      # cpu metric config to scale down
      rule {
        metric_trigger {
          metric_name        = "Percentage CPU"
          metric_resource_id = var.machine_id
          time_grain         = "PT1M"
          statistic          = "Average"
          time_window        = "PT5M"
          time_aggregation   = "Average"
          operator           = "LessThan"
          threshold          = 25
        }

        scale_action {
          direction = "Decrease"
          type      = "ChangeCount"
          value     = "1"
          cooldown  = "PT1M"
        }
      }
    }

    notification {
      email {
        send_to_subscription_administrator    = true
        send_to_subscription_co_administrator = true
        custom_emails                         = ["admin@contoso.com"]
      }
    }
}