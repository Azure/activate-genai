output "eventhub_name" {
  value = var.enable_apim ? azurerm_eventhub_namespace.evh[0].name : ""
}

output "eventhub_id" {
  value = var.enable_apim ? azurerm_eventhub_namespace.evh[0].id : ""
}

output "eventhub_connection_string" {
  value = var.enable_apim ? azurerm_eventhub_namespace.evh[0].default_primary_connection_string : ""
}

