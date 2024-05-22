data "azurerm_subscription" "current" {}

resource "random_id" "random" {
  byte_length = 8
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

locals {
  name_sufix           = substr(lower(random_id.random.hex), 1, 4)
  storage_account_name = "${var.storage_account_name}${local.name_sufix}"
  search_name = "${var.search_name}${local.name_sufix}"
  form_recognizer_name = "${var.form_recognizer_name}${local.name_sufix}"
  azopenai_name = "${var.azopenai_name}${local.name_sufix}"

}

module "vnet" {
  source               = "./modules/vnet"
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = var.virtual_network_name
}

module "nsg" {
  source              = "./modules/nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  nsg_apim_name       = "nsg-apim"
  apim_subnet_id      = module.vnet.apim_subnet_id
  nsg_cae_name        = "nsg-cae"
  cae_subnet_id       = module.vnet.cae_subnet_id
  nsg_pe_name         = "nsg-pe"
  pe_subnet_id        = module.vnet.pe_subnet_id
}

module "apim" {
  source                   = "./modules/apim"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  apim_name                = var.apim_name
  apim_subnet_id           = module.vnet.apim_subnet_id
  publisher_name           = var.publisher_name
  publisher_email          = var.publisher_email
  enable_apim              = var.enable_apim
  appi_resource_id         = module.appi.appi_id
  appi_instrumentation_key = module.appi.appi_key
  openai_service_name      ="test"
  openai_service_endpoint  = "test"
  tenant_id                = data.azurerm_subscription.current.tenant_id

  depends_on = [module.nsg]
}

module "mi" {
  source                = "./modules/mi"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  managed_identity_name = var.managed_identity_name
}

resource "azurerm_role_assignment" "id_reader" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Reader"
  principal_id         = module.mi.principal_id
}


module "log" {
  source              = "./modules/log"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  log_name            = var.log_name
}

module "appi" {
  source              = "./modules/appi"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  appi_name           = var.appi_name
  log_id              = module.log.log_id
}




module "cae" {
  source            = "./modules/cae"
  location          = azurerm_resource_group.rg.location
  resource_group_id = azurerm_resource_group.rg.id
  cae_name          = var.cae_name
  cae_subnet_id     = module.vnet.cae_subnet_id
  log_workspace_id  = module.log.log_workspace_id
  log_key           = module.log.log_key
  appi_key          = module.appi.appi_key
}

module "ca_back" {
  source                         = "./modules/ca-back"
  location                       = azurerm_resource_group.rg.location
  resource_group_id              = azurerm_resource_group.rg.id
  ca_name                        = var.ca_back_name
  cae_id                         = module.cae.cae_id
  managed_identity_id            = module.mi.mi_id
  chat_gpt_deployment            = "test"
  chat_gpt_model                 = "test"
  embeddings_deployment          = "test"
  embeddings_model               = "test"
  storage_account_name           = "test"
  storage_container_name         ="test"
  search_service_name            ="test"
  search_index_name              = "test"
  openai_service_name            = "test"
  tenant_id                      = data.azurerm_subscription.current.tenant_id
  managed_identity_client_id     = module.mi.client_id
  enable_entra_id_authentication = var.enable_entra_id_authentication
}

# module "ca_webapi" {
#   source                     = "./modules/ca-webapi"
#   location                   = azurerm_resource_group.rg.location
#   resource_group_id          = azurerm_resource_group.rg.id
#   ca_name                    = var.ca_webapi_name
#   cae_id                     = module.cae.cae_id
#   cae_default_domain         = module.cae.defaultDomain
#   ca_webapp_name             = var.ca_webapp_name
#   managed_identity_id        = module.mi.mi_id
#   chat_gpt_deployment        = "test"
#   chat_gpt_model             = "test"
#   embeddings_deployment      = "test"
#   embeddings_model           = "test"
#   storage_account_name       = "test"
#   storage_container_name     = module.st.storage_container_name
#   search_service_name        = module.search.search_service_name
#   search_index_name          = module.search.search_index_name
#   openai_service_name        = module.openai.openai_service_name
#   tenant_id                  = data.azurerm_subscription.current.tenant_id
#   managed_identity_client_id = module.mi.client_id
# }

# module "ca_webapp" {
#   source                     = "./modules/ca-webapp"
#   location                   = azurerm_resource_group.rg.location
#   resource_group_id          = azurerm_resource_group.rg.id
#   ca_name                    = var.ca_webapp_name
#   cae_id                     = module.cae.cae_id
#   managed_identity_id        = module.mi.mi_id
#   tenant_id                  = data.azurerm_subscription.current.tenant_id
#   managed_identity_client_id = module.mi.client_id
#   backend_url                = module.ca_webapi.fqdn
# }
