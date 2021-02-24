module "label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.22.0"
  namespace  = var.namespace
  name       = var.name
  stage      = var.stage
  delimiter  = var.char_delimiter
  attributes = []
  tags       = {}
}

# -------------------------------------------------------------------------------------------------
# IAM Role
# -------------------------------------------------------------------------------------------------

resource "aws_iam_role" "this" {
  name = module.label.id

  assume_role_policy = element(concat(data.aws_iam_policy_document.trust_policy.*.json, [""]), 0)
  description        = "description"

  tags = var.tags
}


data "aws_iam_policy_document" "trust_policy" {
  statement {
    effect  = "Allow"
    actions = var.trust_policy_actions

    dynamic "principals" {
      for_each = length(var.federated_principals) > 0 ? [1] : []
      content {
        type        = "Federated"
        identifiers = var.federated_principals
      }
    }

    principals {
      type = "Service"
      identifiers = [
        for service_principal in var.service_principals :
        service_principal
      ]
    }
    principals {
      type = "AWS"
      identifiers = [
        for iam_role_principals_arn in var.iam_role_principals_arns :
        iam_role_principals_arn
      ]
    }

    dynamic "condition" {
      for_each = var.trust_conditions

      content {
        test     = condition.value.test
        variable = condition.value.variable
        values   = condition.value.values
      }
    }
  }
}


data "aws_iam_policy_document" "this" {
  for_each = { for k, v in var.inline_policies : v.name => v }

  dynamic "statement" {
    for_each = each.value.statements

    content {
      sid       = lookup(statement.value, "sid", "")
      effect    = lookup(statement.value, "effect", "Allow")
      actions   = lookup(statement.value, "actions")
      resources = statement.value.resources
    }
  }
}

resource "aws_iam_role_policy" "this" {
  for_each = { for k, v in var.inline_policies : v.name => v }
  name     = each.key
  role     = aws_iam_role.this.id
  policy   = data.aws_iam_policy_document.this[each.key].json
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each   = toset(var.attach_policy_arns)
  role       = aws_iam_role.this.id
  policy_arn = each.value
}
