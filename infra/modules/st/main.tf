resource "azurerm_storage_account" "sa" {
  name                            = var.storage_account_name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  enable_https_traffic_only       = true
  allow_nested_items_to_be_public = false
  # We are enabling the firewall only allowing traffic from our PC's public IP.
  #   network_rules {
  #     default_action             = "Deny"
  #     virtual_network_subnet_ids = []
  #     ip_rules = [
  #       jsondecode(data.http.current_public_ip.body).ip
  #     ]
  #   }
}

# Create data container
resource "azurerm_storage_container" "content" {
  name                  = "content"
  container_access_type = "private"
  storage_account_name  = azurerm_storage_account.sa.name
}

resource "azurerm_role_assignment" "storage_reader" {
  scope                = azurerm_storage_account.sa.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = var.principal_id
}
