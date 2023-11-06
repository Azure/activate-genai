resource "azurerm_eventhub_namespace" "evh" {
  count               = var.enable_apim ? 1 : 0
  name                = var.eventhub_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  capacity            = 1

  # network_rulesets {
  #   default_action                 = "Deny"
  #   trusted_service_access_enabled = true

  #   ip_rule {
  #     ip_mask = "0.0.0.0"
  #   }
  # }

  lifecycle {
    ignore_changes = [
      network_rulesets
    ]
  }
}

resource "azurerm_eventhub" "hub" {
  count               = var.enable_apim ? 1 : 0
  name                = var.eventhub_name
  namespace_name      = azurerm_eventhub_namespace.evh[0].name
  resource_group_name = var.resource_group_name
  partition_count     = 2
  message_retention   = 1
}
