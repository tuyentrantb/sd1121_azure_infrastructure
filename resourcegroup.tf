resource "azurerm_resource_group" "rg" {
  name     = var.project
  location = var.resource_group_location

  tags = module.label.tags
}

module "label" {
  source = "./modules/tags"

  tags = {
    Project = var.project
  }
}
