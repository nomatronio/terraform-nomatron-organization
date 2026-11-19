resource "nomatron_organization" "this" {
  name           = var.name
  description    = var.description
  metadata       = var.metadata
  owner_username = var.owner_username

  lifecycle {
    precondition {
      condition     = var.owner_username == null || !contains(var.members, var.owner_username)
      error_message = "owner_username must not also appear in members; the organization owner is established at creation."
    }

    precondition {
      condition = alltrue([
        for group_name, group in var.groups :
        length(trimspace(group_name)) > 0 &&
        try(length(trimspace(coalesce(group.owner_username, var.owner_username))) > 0, false) &&
        (group.owner_username == null || group.owner_username == var.owner_username || contains(var.members, group.owner_username)) &&
        alltrue([
          for username in group.members :
          length(trimspace(username)) > 0 && (username == var.owner_username || contains(var.members, username))
        ])
      ])
      error_message = "Each group needs a non-empty name and owner. Group owners and members must be the organization owner or an organization member, and group member usernames must not be empty."
    }
  }
}

resource "nomatron_organization_member" "this" {
  for_each = var.members

  org_name = nomatron_organization.this.name
  username = each.value
}

resource "nomatron_group" "this" {
  for_each = var.groups

  org_name       = nomatron_organization.this.name
  name           = each.key
  description    = each.value.description
  metadata       = each.value.metadata
  owner_username = try(coalesce(each.value.owner_username, var.owner_username), "")

  depends_on = [nomatron_organization_member.this]
}

resource "nomatron_group_member" "this" {
  for_each = {
    for item in flatten([
      for group_name, group in var.groups : [
        for username in group.members : {
          key      = "${group_name}/${username}"
          group    = group_name
          username = username
        }
      ]
    ]) : item.key => item
  }

  org_name   = nomatron_organization.this.name
  group_name = nomatron_group.this[each.value.group].name
  username   = each.value.username
}
