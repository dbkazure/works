# Task : 
# 4)	Create an blob  bucket testblob.adusr in a single availability zone.
# 5)	Create an user that has read-only access to just this blob and no other blob

# Provider
provider "azurerm" {
  features {}
}
terraform {
  required_providers {

    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.15.0"
    }
  }
}

# Configure the Azure Active Directory Provider
provider "azuread" {
  tenant_id = "f3bfdc11-1a09-4dc9-b0e4-970415773301"
}


# Resource Group
resource "azurerm_resource_group" "myrg" {
  name     = "blobRG"
  location = "East Asia"
}

# Define the Azure Blob Storage account
resource "azurerm_storage_account" "mystorageaccount" {
  name                     = "mystracct202310162"
  resource_group_name      = azurerm_resource_group.myrg.name
  location                 = azurerm_resource_group.myrg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Define a Blob Container within the storage account
resource "azurerm_storage_container" "devops_container" {
  name                  = "testblob"
  storage_account_name  = azurerm_storage_account.mystorageaccount.name
  container_access_type = "private"
}

resource "azuread_user" "aaduser" {
  user_principal_name   = "user1@dhancloud.onmicrosoft.com"
  display_name          = "User two"
  mail_nickname         = "user2"
  password              = "TempP@55" # Set the user's initial password
  force_password_change = false      # Set to true if the user should change their password on first login
}


# Create an Azure AD role assignment for "user1" with read-only access to the container
resource "azurerm_role_assignment" "myroleassignment" {
  ## principal_id         = "user1_object_id" # Replace with the actual object ID of the use
  principal_id         = azuread_user.aaduser.id
  role_definition_name = "Storage Blob Data Reader" # Grants read-only access to the container
  scope                = azurerm_storage_container.devops_container.resource_manager_id
}