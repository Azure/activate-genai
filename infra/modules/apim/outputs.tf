output "apim_name" {
  value = var.enable_apim ?  azurerm_api_management.apim[0].name : ""
}
