output "oidc_roles_arns" {
  description = "A map of IAM role ARNs indexed by role key"
  value = {
    for key, role in aws_iam_role.this :
    key => role.arn
  }
}

output "oidc_roles_names" {
  description = "A map of IAM role names indexed by role key"
  value = {
    for key, role in aws_iam_role.this :
    key => role.name
  }
}

output "oidc_roles_ids" {
  description = "A map of IAM role IDs indexed by role key"
  value = {
    for key, role in aws_iam_role.this :
    key => role.id
  }
}

output "oidc_provider_arn" {
  description = "The ARN of the IAM OIDC provider"
  value       = try(aws_iam_openid_connect_provider.this[0].arn, null)
}

output "oidc_provider_url" {
  description = "The URL of the IAM OIDC provider"
  value = try(
    aws_iam_openid_connect_provider.this[0].url,
    data.aws_iam_openid_connect_provider.this[0].url,
    null
  )
}

output "gitlab_ci_snippet" {
  description = "GitLab CI/CD YAML snippets for AWS OIDC authentication. Copy and paste into your .gitlab-ci.yml file."
  value = {
    for key, role in aws_iam_role.this : key => chomp(<<-EOT
.assume_aws_role_${key}:
  id_tokens:
    GITLAB_OIDC_TOKEN:
      aud: ${var.aud_value}
  before_script:
    - >
      STS_CREDS=$$(aws sts assume-role-with-web-identity
      --role-arn ${role.arn}
      --role-session-name "gitlab-$${CI_PROJECT_ID}-$${CI_PIPELINE_ID}"
      --web-identity-token "$${GITLAB_OIDC_TOKEN}"
      --duration-seconds ${var.gitlab_oidc_roles[key].max_session_duration}
      --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]'
      --output text)
    - read -r AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN <<< "$$STS_CREDS"
    - export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
    - aws sts get-caller-identity
EOT
    )
  }
}
