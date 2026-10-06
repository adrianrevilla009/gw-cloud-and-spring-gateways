terraform {
  required_version = ">= 1.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.116.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "gw" {
  name     = "rg-orders-apim"
  location = "westeurope"
}

# Consumption tier: pay per call, no idle cost, provisions in minutes.
resource "azurerm_api_management" "orders" {
  name                = "apim-orders-lab"
  location            = azurerm_resource_group.gw.location
  resource_group_name = azurerm_resource_group.gw.name
  publisher_name      = "Orders Lab"
  publisher_email     = "lab@example.com"
  sku_name            = "Consumption_0"
}

resource "azurerm_api_management_api" "orders" {
  name                  = "orders"
  resource_group_name   = azurerm_resource_group.gw.name
  api_management_name   = azurerm_api_management.orders.name
  revision              = "1"
  display_name          = "Orders"
  path                  = "orders"
  protocols             = ["https"]
  service_url           = "https://httpbin.org"
  subscription_required = true
}

resource "azurerm_api_management_api_policy" "orders" {
  api_name            = azurerm_api_management_api.orders.name
  api_management_name = azurerm_api_management.orders.name
  resource_group_name = azurerm_resource_group.gw.name
  xml_content         = file("${path.module}/policy.xml")
}
