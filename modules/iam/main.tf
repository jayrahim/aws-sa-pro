
# Create trust policy for AWS Organizations
data "aws_iam_policy_document" "organizations_trust_policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${var.trusted_account_id}:root",
      ]
    }
  }
}

# Create IAM role for AWS Organizations trust
resource "aws_iam_role" "organizations_trust_role" {
  name                = "OrganizationAccountAccessRole"
  assume_role_policy  = data.aws_iam_policy_document.organizations_trust_policy.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}