output "fqdn" {
  value = jsondecode(azapi_resource.ca_webapp.output).properties.configuration.ingress.fqdn
}
