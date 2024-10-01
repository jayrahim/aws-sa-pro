# Create an organization
resource "aws_organizations_organization" "org" {
  enabled_policy_types = ["SERVICE_CONTROL_POLICY"]
  feature_set          = "ALL"
}

# Create an account for staging withing the organization
resource "aws_organizations_account" "staging" {
  email     = "j.scruggs84+awstrainingstaging@gmail.com"
  name      = "AWS-Training-Staging"
  parent_id = aws_organizations_organizational_unit.ous[0].id
  tags      = local.tags
}

# Create an organziational units
resource "aws_organizations_organizational_unit" "ous" {
  count     = length(var.ou_names)
  name      = var.ou_names[count.index]
  parent_id = aws_organizations_organization.org.roots.0.id
  tags      = local.tags
}

# create a policy to be used for the SCP
data "aws_iam_policy_document" "deny_s3" {
  statement {
    effect    = "Allow"
    actions   = ["*"]
    resources = ["*"]
  }
  statement {
    effect    = "Deny"
    actions   = ["s3:*"]
    resources = ["*"]
  }
}

# Create a service control policy
resource "aws_organizations_policy" "scp_staging" {
  name    = "scp-staging"
  content = data.aws_iam_policy_document.deny_s3.json
}

# Attach the policy to the staging OU
resource "aws_organizations_policy_attachment" "staging" {
  policy_id = aws_organizations_policy.scp_staging.id
  target_id = aws_organizations_organizational_unit.ous[0].id
}
