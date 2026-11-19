mock_provider "nomatron" {}

run "basic_organization" {
  command = apply

  variables {
    name        = "basic-team"
    description = "Basic organization"
  }

  assert {
    condition     = output.name == "basic-team"
    error_message = "The organization name should match the input."
  }

  assert {
    condition     = length(output.member_user_ids) == 0 && length(output.groups) == 0
    error_message = "The basic case should create no members or groups."
  }
}

run "complete_organization" {
  command = apply

  variables {
    name           = "complete-team"
    owner_username = "platform.admin"
    members        = ["platform.engineer", "platform.reviewer"]
    groups = {
      operators = {
        members = ["platform.engineer", "platform.reviewer"]
      }
    }
  }

  assert {
    condition     = toset(keys(nomatron_organization_member.this)) == toset(["platform.engineer", "platform.reviewer"])
    error_message = "Organization member resources should use usernames as keys."
  }

  assert {
    condition     = toset(keys(nomatron_group.this)) == toset(["operators"])
    error_message = "Group resources should use group names as keys."
  }

  assert {
    condition     = toset(keys(nomatron_group_member.this)) == toset(["operators/platform.engineer", "operators/platform.reviewer"])
    error_message = "Group member resources should use group/username keys."
  }
}

run "empty_name_fails" {
  command = plan

  variables {
    name = ""
  }

  expect_failures = [var.name]
}

run "group_owner_required" {
  command = plan

  variables {
    name = "missing-owner-team"
    groups = {
      operators = {}
    }
  }

  expect_failures = [nomatron_organization.this]
}

run "group_member_must_be_organization_member" {
  command = plan

  variables {
    name           = "invalid-member-team"
    owner_username = "platform.admin"
    groups = {
      operators = {
        members = ["platform.outsider"]
      }
    }
  }

  expect_failures = [nomatron_organization.this]
}

run "owner_cannot_be_member" {
  command = plan

  variables {
    name           = "duplicate-owner-team"
    owner_username = "platform.admin"
    members        = ["platform.admin"]
  }

  expect_failures = [nomatron_organization.this]
}
