output "resource_group_name" {
    value = "${azurerm_resource_group.rg.name}"
    description = "The name of the resource group"
}

output "subscription_id" {
    value = "${data.azurerm_subscription.current.subscription_id}"
    description = "The subscription ID used"
}

output "tenant_id" {
    value = "${data.azurerm_subscription.current.tenant_id}"
    description = "The tenant ID used"
}
