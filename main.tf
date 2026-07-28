resource "aws_iam_openid_connect_provider" "this" {
  count = var.create_oidc_provider ? 1 : 0

  url             = var.gitlab_url
  client_id_list  = [local.aud_value]
  thumbprint_list = var.thumbprint_list
  tags            = var.tags
}

data "aws_iam_openid_connect_provider" "this" {
  count = var.create_oidc_provider ? 0 : 1

  arn = var.iam_openid_connect_provider_arn

  lifecycle {
    precondition {
      condition     = var.iam_openid_connect_provider_arn != null
      error_message = "iam_openid_connect_provider_arn must be set when create_oidc_provider is false"
    }
  }
}

data "aws_iam_policy_document" "this" {
  for_each = var.gitlab_oidc_roles

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [local.oidc_provider_arn]
    }
    condition {
      test     = "StringLike"
      variable = "${local.oidc_provider_url}:${each.value.match_field}"
      values   = each.value.repo_paths
    }
  }
}

resource "aws_iam_role" "this" {
  for_each = var.gitlab_oidc_roles

  name                 = each.value.role_name
  description          = each.value.description
  assume_role_policy   = data.aws_iam_policy_document.this[each.key].json
  max_session_duration = each.value.max_session_duration
  permissions_boundary = each.value.permissions_boundary
  path                 = each.value.role_path
  tags                 = merge(var.tags, each.value.role_tags)
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = {
    for item in flatten([
      for role_key, role in var.gitlab_oidc_roles : [
        for policy_key, policy_arn in role.policies : {
          key        = "${role_key}|${policy_key}"
          role_key   = role_key
          policy_arn = policy_arn
        }
      ]
    ]) : item.key => item
  }

  role       = aws_iam_role.this[each.value.role_key].name
  policy_arn = each.value.policy_arn
}

resource "aws_iam_role_policy" "this" {
  for_each = {
    for item in flatten([
      for role_key, role in var.gitlab_oidc_roles : [
        for policy_name, policy_doc in role.inline_policies : {
          key         = "${role_key}-${policy_name}"
          role_key    = role_key
          policy_name = policy_name
          policy      = policy_doc
        }
      ]
    ]) : item.key => item
  }

  name   = each.value.policy_name
  role   = aws_iam_role.this[each.value.role_key].name
  policy = each.value.policy
}
