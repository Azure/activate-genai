resource "azurerm_api_management" "apim" {
  count                = var.enable_apim ? 1 : 0
  name                 = var.apim_name
  location             = var.location
  resource_group_name  = var.resource_group_name
  publisher_name       = var.publisher_name
  publisher_email      = var.publisher_email
  sku_name             = "Developer_1"
  virtual_network_type = "External" # Use "Internal" for a fully private APIM

  virtual_network_configuration {
    subnet_id = var.apim_subnet_id
  }
}
