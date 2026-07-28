## [2.0.0](https://github.com/mariansmolii/terraform-aws-gitlab-oidc/compare/v1.0.2...v2.0.0) (2026-07-28)

### ⚠ BREAKING CHANGES

* the per-role attribute policy_arns (list of ARNs) has
been replaced by policies (map of logical name => ARN), e.g.
policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"] becomes
policies = { readonly = "arn:aws:iam::aws:policy/ReadOnlyAccess" }.
Existing aws_iam_role_policy_attachment resources are recreated in
place during the first apply. The hashicorp/tls provider is no longer
required. For self-managed instances that set only gitlab_url, the
OIDC provider audience now follows gitlab_url instead of staying
https://gitlab.com.

### Features

* rework policy attachments, drop tls dependency and harden module ([#4](https://github.com/mariansmolii/terraform-aws-gitlab-oidc/issues/4)) ([520e338](https://github.com/mariansmolii/terraform-aws-gitlab-oidc/commit/520e338751c74f4b2e1c20cb59160f142a20aa81))

## [1.0.2](https://github.com/mariansmolii/terraform-aws-gitlab-oidc/compare/v1.0.1...v1.0.2) (2026-06-12)

### Bug Fixes

* broken gitlab_ci_snippet output and sub claim format in examples ([#2](https://github.com/mariansmolii/terraform-aws-gitlab-oidc/issues/2)) ([6a9cbc6](https://github.com/mariansmolii/terraform-aws-gitlab-oidc/commit/6a9cbc66f00fbdf0267700268533c2676b920757))

## [1.0.1](https://github.com/mariansmolii/terraform-aws-gitlab-oidc/compare/v1.0.0...v1.0.1) (2026-06-12)

### Bug Fixes

* add .terraform-docs.yml configuration for automated documentation generation ([#1](https://github.com/mariansmolii/terraform-aws-gitlab-oidc/issues/1)) ([21d9dd9](https://github.com/mariansmolii/terraform-aws-gitlab-oidc/commit/21d9dd901456a16bb470009d0b6729f353a778a1))

## 1.0.0 (2026-06-11)

### Features

* add implementation of GitLab OIDC Terraform module with IAM roles and provider configuration ([fa947c0](https://github.com/mariansmolii/terraform-aws-gitlab-oidc/commit/fa947c01f983d248ccf9f7a5616b7cf3ca8adc16))
