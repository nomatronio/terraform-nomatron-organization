output "organization" {
  description = "Organization ID and name."
  value = {
    id   = module.organization.id
    name = module.organization.name
  }
}

output "groups" {
  description = "Created group details."
  value       = module.organization.groups
}
