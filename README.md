# Nomatron Organization Terraform module

This module manages one Nomatron organization, its existing-user memberships, and organization-scoped groups. It does not create users or assign roles. Usernames must already exist in Nomatron; groups and their members are managed separately from role assignments.

## Requirements

| Name | Version |
| --- | --- |
| Terraform | `>= 1.5.0` |
| `nomatronio/nomatron` provider | `~> 0.6` |

## Usage

```hcl
module "organization" {
  source  = "nomatronio/organization/nomatron"
  version = "~> 0.1"

  name           = "example-platform"
  description    = "Platform team organization."
  owner_username = "platform.admin"
  members        = ["platform.engineer", "platform.reviewer"]

  groups = {
    operators = {
      description = "Platform operators."
      members     = ["platform.engineer", "platform.reviewer"]
    }
  }
}
```

Configure the provider in the root module. Supply `address` and `token` using provider variables or environment-backed Terraform variables such as `TF_VAR_nomatron_token`.

The organization owner is set when the organization is created and should not also appear in `members`. Every group requires an owner; when `groups[*].owner_username` is omitted, the organization `owner_username` is used. Group owners and members must be the organization owner or one of `members`.

## Inputs

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `string` | n/a | Organization name. Changing this replaces the organization. |
| `description` | `string` | `null` | Optional organization description. |
| `metadata` | `map(string)` | `null` | Optional organization metadata. |
| `owner_username` | `string` | `null` | Existing Nomatron username to set as organization owner at creation. Changing this replaces the organization. |
| `members` | `set(string)` | `[]` | Existing usernames to add as organization members. Exclude `owner_username`. |
| `groups` | `map(object)` | `{}` | Groups keyed by name. Each object may include `description`, `metadata`, `owner_username`, and `members`. Group owners default to the organization owner. |

## Outputs

| Name | Description |
| --- | --- |
| `id` | Organization ID. |
| `name` | Organization name. |
| `owner_user_id` | Computed owner user ID. |
| `created_at` | Organization creation timestamp. |
| `updated_at` | Organization update timestamp. |
| `member_user_ids` | Map of managed member username to user ID. |
| `groups` | Map of group name to group ID, organization ID, and owner user ID. |

## Examples

- [`examples/basic`](examples/basic) creates one organization.
- [`examples/complete`](examples/complete) creates an organization, members, groups, and group memberships.

## Importing existing resources

Import IDs follow the provider's resource import implementation:

```shell
terraform import 'module.organization.nomatron_organization.this' 'example-platform'
terraform import 'module.organization.nomatron_organization_member.this["platform.engineer"]' 'org_name=example-platform&username=platform.engineer'
terraform import 'module.organization.nomatron_group.this["operators"]' 'example-platform/operators'
terraform import 'module.organization.nomatron_group_member.this["operators/platform.engineer"]' 'org_name=example-platform&group_name=operators&username=platform.engineer'
```

Replace the resource addresses with the addresses in your Terraform configuration. Organization import uses the organization name.

## License

Licensed under the Apache License, Version 2.0. See [LICENSE](LICENSE).
