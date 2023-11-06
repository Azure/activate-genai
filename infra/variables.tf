variable "resource_group_name" {
  default = "rg-activate-genai"
}

variable "location" {
  default = "West Europe"
}

variable "secondary_location" {
  default = "North Europe"
}

variable "log_name" {
  default = "log-activate-genai"
}

variable "azopenai_name" {
  default = "cog-openai-activate-genai"
}

variable "search_name" {
  default = "srch-activate-genai"
}

variable "form_recognizer_name" {
  default = "cog-forms-activate-genai"
}

variable "storage_account_name" {
  default = "stgenai"
}

variable "eventhub_name" {
  default = "evh-activate-genai"
}

variable "apim_name" {
  default = "apim-activate-genai"
}

variable "appi_name" {
  default = "appi-activate-genai"
}

variable "publisher_name" {
  default = "contoso"
}
variable "publisher_email" {
  default = "admin@contoso.com"
}

variable "virtual_network_name" {
  default = "vnet-activate-genai"
}

variable "managed_identity_name" {
  default = "id-activate-genai"
}

variable "cae_name" {
  default = "cae-activate-genai"
}

variable "ca_back_name" {
  default = "ca-back-activate-genai"
}

variable "ca_webapi_name" {
  default = "ca-webapi-activate-genai"
}

variable "ca_webapp_name" {
  default = "ca-webapp-activate-genai"
}

variable "enable_entra_id_authentication" {
  default = false
}

variable "enable_apim" {
  default = false
}
