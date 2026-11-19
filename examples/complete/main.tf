module "organization" {
  source = "../.."

  name           = var.name
  description    = var.description
  owner_username = var.owner_username
  members        = var.members
  groups         = var.groups
}
