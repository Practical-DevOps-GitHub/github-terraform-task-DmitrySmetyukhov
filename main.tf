provider "github" {
  token = var.SECRETS_TOKEN
}
resource "github_repository" "TERRAFORM" {
  name             = "TERRAFORM"
  description      = "TERRAFORM GitHub Repository"
  visibility       = "private"
  has_issues       = true
  has_projects     = true
  has_wiki         = true
  auto_init        = true
}

resource "github_repository_collaborator" "collaborator" {
  repository = github_repository.TERRAFORM.name
  username   = "softservedata"
  permission = "push"
}

resource "github_branch" "develop_branch" {
  repository = github_repository.TERRAFORM.name
  branch     = "develop"
  source_branch = "main"
}

resource "github_branch_default" "default_branch" {
  repository = github_repository.TERRAFORM.name
  branch     = "develop"
  depends_on = [github_branch.develop_branch]
}

resource "github_branch_protection" "main_branch_protection" {
  repository_id = github_repository.TERRAFORM.id
  pattern       = "main"
  
  required_pull_request_reviews {
    dismiss_stale_reviews        = false
    require_code_owner_reviews   = true
    required_approving_review_count = 1
  }
}

resource "github_branch_protection" "develop_branch_protection" {
  repository_id = github_repository.TERRAFORM.id
  pattern       = "develop"

  required_pull_request_reviews {
    dismiss_stale_reviews        = false
    required_approving_review_count = 2
  }
}

resource "github_repository_file" "pull_request_template" {
  repository = github_repository.TERRAFORM.name
  branch     = "main"
  file       = ".github/pull_request_template.md"
  content    = <<EOT
# Pull Request

## Description
Describe the purpose of this pull request.

## Changes Made
List the changes made in this pull request.

## Related Issues
- Include any related issue numbers and links.

## Checklist before requesting a review
- [ ] I have performed a self-review of my code.
- [ ] If it is a core feature, I have added thorough tests.
- [ ] Do we need to implement analytics?
- [ ] Will this be part of a product update? If yes, please write one phrase about this update.
EOT
}

resource "github_repository_deploy_key" "DEPLOY_KEY" {
  repository = "TERRAFORM"
  key        = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCldlMV4SwMl4iwDqEccAKuhTZ8paK53GA92tMBy3mTplGjRk3BVPzhs5BaI/pxoe187Nlj0sYsjzcek6FOws2lmlsUtynfpnWjfvYr9bMDpLQZ0NT2Spt7AyR4iJZ8R2iFkeZQvQQrkXVxKSO4pJPlnHN6Bfa0A8DUMC/n612uqgMR/lst1b+kogxD/YmgnZ7jqCapnwmtyan7PogXc+9rbpd71VqF0uXiEGUyvUrn52xbJM+MLO9y62kELPTXlHsFqS99IOYl/iZ6m2pdt/be0FOaDcuGgk5feXYTru6bAtTqZqrzGSRs9LbS1bRCAvJN5GQOfCC+8RZ86sK4309aIq4ob7ZSBjmbAIAKwz9RkIL5qrlZFqOSevvFiSIHHDQo8Om82ZJ4MHVSVC4vDzr0GasyCVZckl4DNfeAWCO4LM5Nd9f+QkRTCoaICj+XiKxQWfu3+p87WuW8yMOiZAWWSVxuHq/2YJ1pi9eYJ9JoK+lp6Fgh44LZGXU+HWBoavRv86LnZqAc3Sv/ZAiiiEI+/sdoBcLzmgUjLmxhP58fqzwZ575IdLqN7bAqqb78tnpH7PZgc4QCA4gUYcyMivvi/3s/J6D9USMGTGJdt3IghGlOBPl5lG5kcXP5/KTUJu4Vw5J5DUV+p3W3GOzzN8v7EQ0AwZ05VZjr3CtZPcMjBw== dmitry.smetyukhov@gmail.com"
  title      = "DEPLOY_KEY"
  read_only  = true
}
