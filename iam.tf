##### ecs execution role ##########
################################

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "ecsTaskExecutionRole_ak-ecs-task"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role_policy.json
}


resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}




##### ecs role ###################
###########################


resource "aws_iam_role" "ecs_task_role" {
  name               = "ecsTaskRole_ak-ecs-task"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_role_policy.json
}


resource "aws_iam_policy" "s3_access_policy" {
  name        = "s3AccessPolicy"
  description = "Policy for accessing S3"
  policy      = data.aws_iam_policy_document.s3_access_policy.json
}


resource "aws_iam_role_policy_attachment" "ecs_task_role_s3_policy" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}