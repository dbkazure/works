# This will create App service(for hosting .Net app) with CI\CD enabled Github repository. ## Dan 23Nov23
# Note : When developer commits the code in local repo changes automatically get deployed on the web app.
# git add . && git commit -m "test"
# git push -u origin localbranch:remotebranch
# ----------------------------------------------
# Issue noted: Some versions of terraform requires manual import of Github provider. Just run the below command it occurs to you.
# terraform import azurerm_source_control_token.source_control_token /providers/Microsoft.Web/sourceControls/GitHub

provider "azurerm" {
  features {}
}

variable "prefix" {
  description = "The prefix used for all resources"
  type        = string
  default     = "App"
}

variable "location" {
  description = "Location for resources"
  type        = string
  default     = "Central India"
}

variable "plan" {
  description = "Location for resources"
  type        = string
  default     = "F1"
}

variable "repo_url" {
  description = "Mention the repo_url"
  type        = string
}

variable "branch" {
  description = "Mention the branch"
  type        = string
}

variable "github_auth_token" {
  type        = string
  description = "Github Auth Token from Github > Developer Settings > Personal Access Tokens > Tokens Classic (needs to have repo and workflow permission)"
}

locals {
  location = var.location
  prefix   = var.prefix
  plan     = var.plan
  repo     = var.repo_url
  branch   = var.branch
}

resource "azurerm_resource_group" "main" {
  name     = "${local.prefix}-resources"
  location = local.location
}

resource "azurerm_service_plan" "main" {
  name                = "${local.prefix}-asp"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  os_type             = "Windows"
  sku_name            = local.plan
}

# Create Windows Webapp
resource "azurerm_windows_web_app" "main" {
  name                = "${local.prefix}-appservice"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  service_plan_id     = azurerm_service_plan.main.id
  site_config {
    remote_debugging_enabled = true
    remote_debugging_version = "VS2019"
    always_on                = false
  }
}

resource "azurerm_source_control_token" "source_control_token" {
  type         = "GitHub"
  token        = var.github_auth_token
  token_secret = var.github_auth_token
}

resource "azurerm_app_service_source_control" "cicdrepo" {
  app_id   = azurerm_windows_web_app.main.id
  repo_url = local.repo
  branch   = local.branch
  github_action_configuration {
    code_configuration {
      runtime_stack   = "dotnetcore"
      runtime_version = "6.0"
    }
  }
}
