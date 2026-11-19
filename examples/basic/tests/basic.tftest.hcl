mock_provider "nomatron" {}

run "basic_example_plan" {
  command = plan

  variables {
    nomatron_address = "https://example.invalid"
    nomatron_token   = "placeholder-token"
    name             = "example-team"
    description      = "Example organization managed with Terraform."
  }

  assert {
    condition     = length(module.organization.member_user_ids) == 0 && length(module.organization.groups) == 0
    error_message = "The basic example should create only one organization."
  }
}
