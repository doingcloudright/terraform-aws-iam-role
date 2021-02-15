variable "namespace" {
  description = "The organization name provisioning the template (e.g. acme)"
}

variable "stage" {
  description = "Stage e.g. dev/prod"
}

variable "char_delimiter" {
  description = "The delimiter to use for unique names (default: -)"
  default     = "-"
}

variable "name" {
  description = "Name of the role"
}

variable "tags" {
  description = "Tags applied to the resources"
  type        = map(string)
  default     = {}
}

variable "inline_policies" {
  description = "Policies applied to the assuming role"
  default     = []
  type = list(object({
    name = string
    statements = list(object({
      actions   = list(string)
      resources = list(string)
    }))
  }))
}

variable "attach_policy_arns" {
  description = "Policy arns  attacherd to the assuming role"
  type        = list(string)
  default     = []
}

variable "iam_role_principals_arns" {
  description = "Other IAM Principals which can assume the role"
  type        = list(string)
  default     = []
}


variable "service_principals" {
  description = "IAM service Principals which can assume the role"
  type        = list(string)
  default     = []
}

variable "federated_principals" {
  description = "Federated principals which can assume the role"
  type        = list(string)
  default     = []
}

variable "trust_conditions" {
  description = "Conditions on the trust policy"
  type        = any
  default     = []
}

variable "trust_policy_actions" {
  description = "List of actions allowed, defaults to sts:AssumeRole"
  type        = list(string)
  default     = ["sts:AssumeRole"]
}
