#
# data.tf
#
###############################################################################
#
# Account ID
#
data "aws_caller_identity" "current" {}
#
# Region
#
data "aws_region" "current" {}
#
# frontend-stage VPC
#
data "aws_vpc" "ak_ecs_vpc" {
  id = "vpc-064212ae5e94c2803"
}



## ecs execution_role_policy ######
####################################


data "aws_iam_policy_document" "ecs_task_execution_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}


### ecs role policy #####
#############################


data "aws_iam_policy_document" "ecs_task_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}



data "aws_iam_policy_document" "s3_access_policy" {

  statement {
    sid = "SSMRemoteAttach"

    actions = [
        "ecs:CreateService",
        "ecs:DescribeServices",
        "ecs:UpdateService",
        "ecs:DeleteService"
    ]

    resources = ["*"]
  }  
  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::example-bucket",
      "arn:aws:s3:::example-bucket/*"
    ]
  }
}
