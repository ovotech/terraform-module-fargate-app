# create ci/cd user with access keys (for build system)
variable "ecr_repository_arn" {}

variable "additional_user_groups" {
  default = []
}

resource "aws_iam_user" "cicd" {
  name = "srv_${var.app}_${var.environment}_cicd"
}

resource "aws_iam_group" "cicd" {
  name = "srv_${var.app}_${var.environment}_cicd"
}

resource "aws_iam_user_group_membership" "cicd" {
  user = aws_iam_user.cicd.name

  groups = concat([aws_iam_group.cicd.name], var.additional_user_groups)
}

# grant required permissions to deploy
data "aws_iam_policy_document" "cicd_policy" {
  # allows user to push/pull to the registry
  statement {
    sid = "ecr"

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
    ]

    resources = [
      var.ecr_repository_arn
    ]
  }

  # allows user to deploy to ecs
  statement {
    sid = "ecs"

    actions = [
      "ecr:GetAuthorizationToken",
      "ecs:DescribeServices",
      "ecs:DescribeTaskDefinition",
      "ecs:UpdateService",
      "ecs:RegisterTaskDefinition",
      "ecs:TagResource"
    ]

    resources = [
      "*",
    ]
  }

  # allows user to run ecs task using task execution and app roles
  statement {
    sid = "approle"

    actions = [
      "iam:PassRole",
    ]

    resources = [
      aws_iam_role.app_role.arn,
      aws_iam_role.ecsTaskExecutionRole.arn,
    ]
  }

  # allows user to manipulate its own access keys
  statement {
    sid = "accessKeys"

    actions = [
      "iam:DeleteAccessKey",
      "iam:GetAccessKeyLastUsed",
      "iam:UpdateAccessKey",
      "iam:CreateAccessKey",
      "iam:ListAccessKeys",
    ]

    resources = [
      aws_iam_user.cicd.arn,
    ]
  }

  # allow user to get data from s3 buckets
  statement {
    sid = "s3access"

    actions =[
      "s3:GetObject"
    ]

    resources = [
      "arn:aws:s3:::*",
    ]
  }
}

resource "aws_iam_group_policy" "cicd_group_policy" {
  name   = "${var.app}_${var.environment}_cicd"
  group   = aws_iam_group.cicd.name
  policy = data.aws_iam_policy_document.cicd_policy.json
}

