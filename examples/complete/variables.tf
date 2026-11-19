variable "name" {
  type        = string
  description = "Organization name."
  default     = "example-platform"
}

variable "description" {
  type        = string
  description = "Organization description."
  default     = "Platform team organization."
}

variable "owner_username" {
  type        = string
  description = "Username of an existing organization owner."
  default     = "platform.admin"
}

variable "members" {
  type        = set(string)
  description = "Existing usernames to add to the organization."
  default     = ["platform.admins", "platform.engineer"]
}

variable "groups" {
  type = map(object({
    description = optional(string)
    members     = optional(set(string), [])
  }))
  description = "Groups and their existing organization members."
  default = {
    operators = {
      description = "Platform operators."
      members     = ["platform.admins", "platform.engineer"]
    }
  }
}
