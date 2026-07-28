locals {
  aud_value         = coalesce(var.aud_value, var.gitlab_url)
  oidc_provider_arn = var.create_oidc_provider ? one(aws_iam_openid_connect_provider.this[*].arn) : one(data.aws_iam_openid_connect_provider.this[*].arn)
  oidc_provider_url = var.create_oidc_provider ? one(aws_iam_openid_connect_provider.this[*].url) : one(data.aws_iam_openid_connect_provider.this[*].url)
}
