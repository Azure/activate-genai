resource "azapi_resource" "ca_webapi" {
  name      = var.ca_name
  location  = var.location
  parent_id = var.resource_group_id
  type      = "Microsoft.App/containerApps@2022-11-01-preview"
  identity {
    type = "UserAssigned"
    identity_ids = [
      var.managed_identity_id
    ]
  }

  body = jsonencode({
    properties : {
      managedEnvironmentId = "${var.cae_id}"
      configuration = {
        secrets = []
        ingress = {
          external   = true
          targetPort = 8080
          transport  = "Http"

          traffic = [
            {
              latestRevision = true
              weight         = 100
            }
          ]
          corsPolicy = {
            allowedOrigins = [
              "https://${var.ca_webapp_name}.${var.cae_default_domain}"
            ]
            allowedHeaders   = ["*"]
            allowCredentials = false
          }
        }
        dapr = {
          enabled = false
        }
      }
      template = {
        containers = [
          {
            name  = "chat-copilot-webapi"
            image = "cmendibl3/chat-copilot-webapi:0.1.0"
            resources = {
              cpu    = 0.5
              memory = "1Gi"
            }
            env = [
              {
                name  = "Authentication__Type"
                value = "None"
              },
              {
                name  = "Planner__Model"
                value = "${var.chat_gpt_model}"
              },
              {
                name  = "SemanticMemory__Services__AzureOpenAIText__Endpoint"
                value = "https://${var.openai_service_name}.openai.azure.com/"
              },
              {
                name  = "SemanticMemory__Services__AzureOpenAIText__Deployment"
                value = "${var.chat_gpt_model}"
              },
              {
                name  = "SemanticMemory__Services__AzureOpenAIText__Auth"
                value = "AzureIdentity"
              },
              {
                name  = "SemanticMemory__Services__AzureOpenAIEmbedding__Endpoint"
                value = "https://${var.openai_service_name}.openai.azure.com/"
              },
              {
                name  = "SemanticMemory__Services__AzureOpenAIEmbedding__Deployment"
                value = "${var.embeddings_model}"
              },
              {
                name  = "SemanticMemory__Services__AzureOpenAIEmbedding__Auth"
                value = "AzureIdentity"
              },
              {
                name  = "AZURE_TENANT_ID"
                value = "${var.tenant_id}"
              },
              {
                name  = "AZURE_CLIENT_ID"
                value = "${var.managed_identity_client_id}"
              },
            ],
          },
        ]
        scale = {
          minReplicas = 1
          maxReplicas = 1
        }
      }
    }
  })
  response_export_values = ["properties.configuration.ingress.fqdn"]
}
