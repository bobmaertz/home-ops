terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }

  cloud {
    organization = "bobmaertz-org"

    workspaces {
      name = "github-settings"
    }
  }
}

# Authentication: set GITHUB_TOKEN as a sensitive environment variable
# in the Terraform Cloud workspace (TFC UI → Variables → Environment Variables).
# Token requires scopes: repo, admin:org (for runner group management).
provider "github" {
  owner = "bobmaertz"
}
