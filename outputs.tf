output "id" {
  description = "Organization ID (nomatron_organization.id)."
  value       = nomatron_organization.this.id
}

output "name" {
  description = "Organization name."
  value       = nomatron_organization.this.name
}

output "owner_user_id" {
  description = "Owner user ID computed by the provider. Empty or unset if no owner was applied."
  value       = nomatron_organization.this.owner_user_id
}

output "created_at" {
  description = "RFC3339 timestamp when the organization was created."
  value       = nomatron_organization.this.created_at
}

output "updated_at" {
  description = "RFC3339 timestamp when the organization was last updated."
  value       = nomatron_organization.this.updated_at
}

output "member_user_ids" {
  description = "Map of username to user_id for organization members managed by this module."
  value       = { for username, member in nomatron_organization_member.this : username => member.user_id }
}

output "groups" {
  description = "Map of group name to group id, organization_id, and owner_user_id."
  value = {
    for name, group in nomatron_group.this : name => {
      id              = group.id
      name            = group.name
      organization_id = group.organization_id
      owner_user_id   = group.owner_user_id
    }
  }
}
