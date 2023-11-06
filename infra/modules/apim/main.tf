locals {
  logger_name = "openai-logger"
}

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

// TODO: https://learn.microsoft.com/en-us/azure/api-management/api-management-howto-log-event-hubs?tabs=bicep#logger-with-system-assigned-managed-identity-credentialss
resource "azurerm_api_management_logger" "logger" {
  count               = var.enable_apim ? 1 : 0
  name                = local.logger_name
  api_management_name = azurerm_api_management.apim[0].name
  resource_group_name = var.resource_group_name
  resource_id         = var.eventhub_id

  eventhub {
    name              = var.eventhub_name
    connection_string = var.eventhub_connection_string
  }
}

// https://learn.microsoft.com/en-us/semantic-kernel/deploy/use-ai-apis-with-api-management#setup-azure-api-management-instance-with-azure-openai-api
resource "azurerm_api_management_api" "openai" {
  count                 = var.enable_apim ? 1 : 0
  name                  = "openai-api"
  resource_group_name   = var.resource_group_name
  api_management_name   = azurerm_api_management.apim[0].name
  revision              = "1"
  display_name          = "Azure Open AI API"
  path                  = "openai"
  protocols             = ["https"]
  subscription_required = false

  import {
    content_format = "openapi"
    content_value  = replace(replace(file("${path.module}/azure_openai.json"), "{endpoint}", var.openai_service_endpoint), "{servicename}", var.openai_service_name)
  }
}

resource "azurerm_api_management_named_value" "tenant_id" {
  count               = var.enable_apim ? 1 : 0
  name                = "tenant-id"
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.apim[0].name
  display_name        = "TENANT_ID"
  value               = var.tenant_id
}

resource "azurerm_api_management_named_value" "logger_compliance" {
  count               = var.enable_apim ? 1 : 0
  name                = "logger-compliance"
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.apim[0].name
  display_name        = "YOUR_LOGGER_COMPLIANCE"
  value               = local.logger_name
}

resource "azurerm_api_management_named_value" "logger_chargeback" {
  count               = var.enable_apim ? 1 : 0
  name                = "logger-chargeback"
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.apim[0].name
  display_name        = "YOUR_LOGGER_CHARGEBACK"
  value               = local.logger_name
}

// https://github.com/mattfeltonma/azure-openai-apim/blob/main/apim-policies/apim-policy-event-hub-logging.xml
resource "azurerm_api_management_api_policy" "policy" {
  count               = var.enable_apim ? 1 : 0
  api_name            = azurerm_api_management_api.openai[0].name
  api_management_name = azurerm_api_management.apim[0].name
  resource_group_name = var.resource_group_name

  xml_content = <<XML
    <!--
    This sample policy enforces Azure AD authentication and authorization to the Azure OpenAI Service. 
    It limits the authorization tokens issued by the organization's tenant for Cognitive Services.
    The authorization token is passed on to the Azure OpenAI Service ensuring authorization to the actions within
    the service are limited to the permissions defined in Azure RBAC.

    The sample policy also logs audit information such as the application id making the call, the prompt, the response, 
    the model used, and the number of tokens consumed. This can be helpful when handling chargebacks. The events are delivered
    to an Azure Event Hub through the Azure API Management Logger.

    You must provide values for the AZURE_OAI_SERVICE_NAME, TENANT_ID, YOUR_LOGGER_COMPLIANCE, and YOUR_LOGGER_CHARGEBACK a parameters.
    You can use separate APIM Loggers for compliance and chargeback or the same logger. It is your choice.
    -->
    <policies>
        <inbound>
            <base />
            <validate-jwt header-name="Authorization" failed-validation-httpcode="403" failed-validation-error-message="Forbidden">
                <openid-config url="https://login.microsoftonline.com/{{TENANT_ID}}/v2.0/.well-known/openid-configuration" />
                <issuers>
                    <issuer>https://sts.windows.net/{{TENANT_ID}}/</issuer>
                </issuers>
                <required-claims>
                    <claim name="aud">
                        <value>https://cognitiveservices.azure.com</value>
                    </claim>
                </required-claims>
            </validate-jwt>
           
            <set-variable name="message-id" value="@(Guid.NewGuid())" />

            <log-to-eventhub logger-id="{{YOUR_LOGGER_COMPLIANCE}}" partition-id="0">@{
                var requestBody = context.Request.Body?.As<JObject>(true);

                string prompt = requestBody["prompt"]?.ToString();
                string messages = requestBody["messages"]?.ToString();

                return new JObject(
                    new JProperty("event-time", DateTime.UtcNow.ToString()),
                    new JProperty("message-id", context.Variables["message-id"]),
                    new JProperty("appid", context.Request.Headers.GetValueOrDefault("Authorization",string.Empty).Split(' ').Last().AsJwt().Claims.GetValueOrDefault("appid", string.Empty)),
                    new JProperty("operationname", context.Operation.Id),
                    new JProperty("prompt", prompt),
                    new JProperty("messages", messages)
                ).ToString();
            }</log-to-eventhub>
        </inbound>
        <backend>
          <base />
        </backend>
        <outbound>
            <base />
        </outbound>
        <on-error>
          <base />
        </on-error>
    </policies>
    XML
}
