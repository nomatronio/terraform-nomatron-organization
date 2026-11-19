variable "name" {
  type        = string
  description = "Organization name. Maps to nomatron_organization.name. Changing this replaces the organization."

  validation {
    condition     = length(trimspace(var.name)) > 0
    error_message = "name must be a non-empty string."
  }
}

variable "description" {
  type        = string
  default     = null
  description = "Optional organization description. Maps to nomatron_organization.description."
}

variable "metadata" {
  type        = map(string)
  default     = null
  description = "Optional metadata map attached to the organization. Maps to nomatron_organization.metadata (map of string)."
}

variable "owner_username" {
  type        = string
  default     = null
  description = "Optional owner username set at organization creation. Maps to nomatron_organization.owner_username. Changing this replaces the organization. This user must already exist in Nomatron."
}

variable "members" {
  type        = set(string)
  default     = []
  description = "Usernames of existing Nomatron users to add as organization members. Each value maps to nomatron_organization_member.username. Do not include the owner_username; the owner is established at organization creation."

  validation {
    condition     = alltrue([for username in var.members : length(trimspace(username)) > 0])
    error_message = "members must be non-empty usernames."
  }
}

variable "groups" {
  type = map(object({
    description    = optional(string)
    metadata       = optional(map(string))
    owner_username = optional(string)
    members        = optional(set(string), [])
  }))
  default     = {}
  description = <<-EOT
    Map of organization-scoped groups, keyed by group name. The map key is used as nomatron_group.name (RequiresReplace).
    owner_username is required by the provider. If omitted on a group, the module uses var.owner_username. If both are null, Terraform must fail with a clear error.
    members are existing usernames added via nomatron_group_member. Each group member must also be an organization member (var.members) or the organization owner (var.owner_username).
  EOT
}
