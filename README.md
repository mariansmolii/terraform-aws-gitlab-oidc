# GitLab OIDC Terraform Module

Terraform module to create AWS IAM OIDC provider and roles for GitLab CI/CD pipelines authentication.

## Usage

```hcl
module "gitlab_oidc" {
  source = "mariansmolii/gitlab-oidc/aws"

  create_oidc_provider = true

  gitlab_oidc_roles = {
    production = {
      role_name   = "gitlab-production-role"
      description = "Role for GitLab CI/CD production deployments"
      repo_paths  = ["my-org/my-app:ref_type:branch:ref:main", "my-org/my-app:ref_type:tag:ref:v*"]
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
      repo_paths           = ["my-org/my-app:ref_type:branch:ref:develop"]
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

<!-- BEGIN_TF_DOCS -->



## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 4.1.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.0.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | >= 4.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [aws_iam_openid_connect_provider.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_openid_connect_provider.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_openid_connect_provider) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [tls_certificate.this](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_aud_value"></a> [aud\_value](#input\_aud\_value) | The audience value to use for the OIDC provider | `string` | `"https://gitlab.com"` | no |
| <a name="input_create_oidc_provider"></a> [create\_oidc\_provider](#input\_create\_oidc\_provider) | Whether to create a new IAM OIDC provider or use an existing one | `bool` | `true` | no |
| <a name="input_gitlab_oidc_roles"></a> [gitlab\_oidc\_roles](#input\_gitlab\_oidc\_roles) | A map of roles to create for GitLab OIDC authentication | <pre>map(object({<br/>    role_name            = string<br/>    description          = optional(string, null)<br/>    repo_paths           = list(string)<br/>    match_field          = optional(string, "sub")<br/>    policy_arns          = optional(list(string), [])<br/>    inline_policies      = optional(map(string), {})<br/>    max_session_duration = optional(number, 3600)<br/>    role_path            = optional(string, "/")<br/>    role_tags            = optional(map(string), {})<br/>    permissions_boundary = optional(string, null)<br/>  }))</pre> | n/a | yes |
| <a name="input_gitlab_url"></a> [gitlab\_url](#input\_gitlab\_url) | The URL of the GitLab instance to use as the OIDC provider | `string` | `"https://gitlab.com"` | no |
| <a name="input_iam_openid_connect_provider_arn"></a> [iam\_openid\_connect\_provider\_arn](#input\_iam\_openid\_connect\_provider\_arn) | The ARN of the existing IAM OIDC provider to use if create\_oidc\_provider is false | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to apply to all resources created by this module | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_gitlab_ci_snippet"></a> [gitlab\_ci\_snippet](#output\_gitlab\_ci\_snippet) | GitLab CI/CD YAML snippets for AWS OIDC authentication. Copy and paste into your .gitlab-ci.yml file. |
| <a name="output_oidc_provider_arn"></a> [oidc\_provider\_arn](#output\_oidc\_provider\_arn) | The ARN of the IAM OIDC provider |
| <a name="output_oidc_provider_url"></a> [oidc\_provider\_url](#output\_oidc\_provider\_url) | The URL of the IAM OIDC provider |
| <a name="output_oidc_roles_arns"></a> [oidc\_roles\_arns](#output\_oidc\_roles\_arns) | A map of IAM role ARNs indexed by role key |
| <a name="output_oidc_roles_ids"></a> [oidc\_roles\_ids](#output\_oidc\_roles\_ids) | A map of IAM role IDs indexed by role key |
| <a name="output_oidc_roles_names"></a> [oidc\_roles\_names](#output\_oidc\_roles\_names) | A map of IAM role names indexed by role key |
<!-- END_TF_DOCS -->
