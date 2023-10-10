output "fqdn" {
  value = jsondecode(azapi_resource.ca_webapi.output).properties.configuration.ingress.fqdn
}

