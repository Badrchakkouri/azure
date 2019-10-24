// I only specify the aeurerm provider
// For connection to Azure I will be using the service principal authentication methode
// Check this for more: https://www.terraform.io/docs/providers/azurerm/auth/service_principal_client_secret.html
// I only need to define the env variables below and then terraform will handle the authentication
// ARM_CLIENT_ID, ARM_CLIENT_SECRET, ARM_SUBSCRIPTION_ID, ARM_TENANT_ID

provider "azurerm" {
}