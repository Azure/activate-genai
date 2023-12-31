resource "azurerm_cognitive_account" "openai" {
  name                          = var.azopenai_name
  kind                          = "OpenAI"
  sku_name                      = "S0"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  public_network_access_enabled = true
  custom_subdomain_name         = var.azopenai_name
}

resource "azurerm_cognitive_deployment" "gpt_35_turbo" {
  name                 = "gpt-35-turbo"
  cognitive_account_id = azurerm_cognitive_account.openai.id
  rai_policy_name      = "Microsoft.Default"
  model {
    format  = "OpenAI"
    name    = "gpt-35-turbo"
    version = "0301"
  }

  scale {
    type     = "Standard"
    capacity = 120
  }
}

resource "azurerm_cognitive_deployment" "embedding" {
  name                 = "text-embedding-ada-002"
  cognitive_account_id = azurerm_cognitive_account.openai.id
  rai_policy_name      = "Microsoft.Default"
  model {
    format  = "OpenAI"
    name    = "text-embedding-ada-002"
    version = "2"
  }

  scale {
    type     = "Standard"
    capacity = 120
  }
}

resource "azurerm_role_assignment" "openai_user" {
  scope                = azurerm_cognitive_account.openai.id
  role_definition_name = "Cognitive Services OpenAI User"
  principal_id         = var.principal_id
}

# resource "azurerm_cognitive_account" "secondary_openai" {
#   name                          = var.azopenai_name
#   kind                          = "OpenAI"
#   sku_name                      = "S0"
#   location                      = var.secondary_location
#   resource_group_name           = var.resource_group_name
#   public_network_access_enabled = true
#   custom_subdomain_name         = var.azopenai_name
# }

# resource "azurerm_cognitive_deployment" "secondary_gpt_35_turbo" {
#   name                 = "gpt-35-turbo"
#   cognitive_account_id = azurerm_cognitive_account.secondary_openai.id
#   rai_policy_name      = "Microsoft.Default"
#   model {
#     format  = "OpenAI"
#     name    = "gpt-35-turbo"
#     version = "0301"
#   }

#   scale {
#     type     = "Standard"
#     capacity = 120
#   }
# }

# resource "azurerm_cognitive_deployment" "secondary_embedding" {
#   name                 = "text-embedding-ada-002"
#   cognitive_account_id = azurerm_cognitive_account.secondary_openai.id
#   rai_policy_name      = "Microsoft.Default"
#   model {
#     format  = "OpenAI"
#     name    = "text-embedding-ada-002"
#     version = "2"
#   }

#   scale {
#     type     = "Standard"
#     capacity = 239
#   }
# }
