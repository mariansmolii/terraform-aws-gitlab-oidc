# Complete example

Complete example of the GitLab OIDC module: creates the IAM OIDC provider and roles with managed and inline policies for GitLab CI/CD pipelines authentication.

## Usage

To run this example you need to execute:

```bash
terraform init
terraform plan
terraform apply
```

```hcl
module "gitlab_oidc" {
  source = "../../"

  create_oidc_provider = true

  gitlab_oidc_roles = {
    production = {
      role_name   = "gitlab-production-role"
      description = "Role for GitLab CI/CD production deployments"
      repo_paths  = ["project_path:my-org/my-app:ref_type:branch:ref:main", "project_path:my-org/my-app:ref_type:tag:ref:v*"]
      match_field = "sub"
      policy_arns = ["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"]
      inline_policies = {
        s3-write = jsonencode({
          Version = "2012-10-17"
          Statement = [
            {
              Effect   = "Allow"
              Action   = ["s3:PutObject", "s3:DeleteObject"]
              Resource = "arn:aws:s3:::my-production-bucket/*"
            }
          ]
        })
      }
      max_session_duration = 7200
      role_path            = "/gitlab/"
      role_tags = {
        Environment = "production"
      }
    }

    staging = {
      role_name            = "gitlab-staging-role"
      description          = "Role for GitLab CI/CD staging deployments"
      repo_paths           = ["project_path:my-org/my-app:ref_type:branch:ref:develop"]
      match_field          = "sub"
      policy_arns          = ["arn:aws:iam::aws:policy/PowerUserAccess"]
      max_session_duration = 3600
      role_path            = "/gitlab/"
      role_tags = {
        Environment = "staging"
      }
    }
  }

  tags = {
    managedBy = "Terraform"
    team      = "DevOps"
  }
}
```

## Outputs

```hcl
output "roles_arn" {
  value = module.gitlab_oidc.oidc_roles_arns
}

output "roles_name" {
  value = module.gitlab_oidc.oidc_roles_names
}

output "roles_ids" {
  value = module.gitlab_oidc.oidc_roles_ids
}

output "oidc_provider_arn" {
  value = module.gitlab_oidc.oidc_provider_arn
}

output "oidc_provider_url" {
  value = module.gitlab_oidc.oidc_provider_url
}

output "gitlab_ci_snippet" {
  value = module.gitlab_oidc.gitlab_ci_snippet
}
```
