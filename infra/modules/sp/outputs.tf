output "client_id" {
  value = azuread_service_principal.sp.client_id
}

output "object_id" {
  value = azuread_service_principal.sp.object_id
}

output "id" {
  value = azuread_service_principal.sp.id
}

output "password" {
  value = azuread_service_principal_password.sp.value
}
