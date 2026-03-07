# Repos that use the self-hosted-orion runner and push to the private registry.
# Add a repo name to var.runner_repos to have its secrets and settings managed here.

locals {
  runner_repos = toset(var.runner_repos)
}

# ── Actions secrets ────────────────────────────────────────────────────────────
# Inject registry credentials into each repo so workflows can authenticate
# to registry.bou1der.net. These replace the manual "Settings → Secrets" step.

resource "github_actions_secret" "registry_username" {
  for_each        = local.runner_repos
  repository      = each.value
  secret_name     = "REGISTRY_USERNAME"
  plaintext_value = var.registry_username
}

resource "github_actions_secret" "registry_password" {
  for_each        = local.runner_repos
  repository      = each.value
  secret_name     = "REGISTRY_PASSWORD"
  plaintext_value = var.registry_password
}

# ── Actions permissions ────────────────────────────────────────────────────────
# For each repo, restrict which Actions are allowed to run.
# "local_only" permits only actions defined within the same repo plus
# actions from GitHub (github.com/actions/*) and verified Marketplace creators.
# This blocks unknown third-party actions that could exfiltrate secrets.

resource "github_actions_repository_permissions" "runner_repos" {
  for_each        = local.runner_repos
  repository      = each.value
  allowed_actions = "selected"

  allowed_actions_config {
    github_owned_allowed  = true  # actions/checkout, actions/setup-*, etc.
    verified_allowed      = true  # verified Marketplace publishers (docker/*, aquasecurity/*)
    patterns_allowed      = []    # add specific third-party actions here if needed
  }
}

# ── Fork PR approval ───────────────────────────────────────────────────────────
# The "Require approval for fork pull request workflows" setting is not yet
# exposed by the GitHub Terraform provider for personal accounts. Set this
# manually per repo:
#   Settings → Actions → General →
#   "Fork pull request workflows from outside collaborators" →
#   "Require approval for all outside collaborators"
#
# Track the upstream issue: https://github.com/integrations/terraform-provider-github/issues/1872
