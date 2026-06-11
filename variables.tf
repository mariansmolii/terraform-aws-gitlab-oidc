variable "create_oidc_provider" {
  description = "Whether to create a new IAM OIDC provider or use an existing one"
  type        = bool
  default     = true
}

variable "iam_openid_connect_provider_arn" {
  description = "The ARN of the existing IAM OIDC provider to use if create_oidc_provider is false"
  type        = string
  default     = null
}

variable "gitlab_url" {
  description = "The URL of the GitLab instance to use as the OIDC provider"
  type        = string
  default     = "https://gitlab.com"

  validation {
    condition     = can(regex("^https://", var.gitlab_url))
    error_message = "The gitlab_url must start with 'https://'"
  }
}

variable "aud_value" {
  description = "The audience value to use for the OIDC provider"
  type        = string
  default     = "https://gitlab.com"
}

variable "gitlab_oidc_roles" {
  description = "A map of roles to create for GitLab OIDC authentication"
  type = map(object({
    role_name            = string
    description          = optional(string, null)
    repo_paths           = list(string)
    match_field          = optional(string, "sub")
    policy_arns          = optional(list(string), [])
    inline_policies      = optional(map(string), {})
    max_session_duration = optional(number, 3600)
    role_path            = optional(string, "/")
    role_tags            = optional(map(string), {})
    permissions_boundary = optional(string, null)
  }))

  validation {
    condition = alltrue([
      for k, v in var.gitlab_oidc_roles :
      v.max_session_duration >= 3600 && v.max_session_duration <= 43200
    ])
    error_message = "max_session_duration must be between 3600 (1 hour) and 43200 (12 hours) seconds"
  }

  validation {
    condition = alltrue([
      for k, v in var.gitlab_oidc_roles :
      length(v.repo_paths) > 0
    ])
    error_message = "repo_paths must contain at least one path"
  }
}

variable "tags" {
  description = "A map of tags to apply to all resources created by this module"
  type        = map(string)
  default     = {}
}
