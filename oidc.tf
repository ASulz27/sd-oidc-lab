variable "github_owner" {
  type = string
}

resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
}

resource "aws_iam_role" "gha" {
  name = "sd-gha-oidc"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Federated = aws_iam_openid_connect_provider.github.arn }
      Action    = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
        }
        StringLike = {
          "token.actions.githubusercontent.com:sub" = "repo:${var.github_owner}/sd-oidc-lab:ref:refs/heads/main"
        }
      }
    }]
  })
}


resource "aws_iam_role_policy" "audit" {
  name = "credential-audit"
  role = aws_iam_role.gha.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["secretsmanager:ListSecrets", "iam:ListUsers", "iam:ListAccessKeys"]
      Resource = "*"
    }]
  })
}

output "role_arn" {
  value = aws_iam_role.gha.arn
}











 