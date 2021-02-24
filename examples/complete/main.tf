module "assumed-saml-role" {
  source = "../../"

  namespace = "eg"
  stage     = "stage"

  name = "role-read-only"

  attach_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]

  inline_policies = [
    {
      name = "cloudfront"
      statements = [
        {
          actions = [
            "cloudfront:CreateInvalidation"
          ]
          resources = ["*"]
        },
      ],
    },
    {
      name = "cloudfront_all"
      statements = [
        {
          actions = [
            "cloudfront:*"
          ]
          resources = ["*"]
        },
      ],
    }
  ]
}

