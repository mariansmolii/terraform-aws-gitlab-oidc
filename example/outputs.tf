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
