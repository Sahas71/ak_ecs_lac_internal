#
# ecr.tf
#
###############################################################################
#
# ak-ecs Cluster
#
resource "aws_ecs_cluster" "ak-ecs-task" {
  name = "ak-ecs-task"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = merge(tomap({ "Name" = "ak-ecs-task" }), local.ecs_cluster_tags)
}

resource "aws_ecs_cluster_capacity_providers" "ak-ecs-task" {
  cluster_name = aws_ecs_cluster.ak-ecs-task.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

#
# ak-ecs task_definition
#
resource "aws_ecs_task_definition" "nginx_task" {
  family                   = "nginx-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "nginx"
      image     = "nginx:latest"
      essential = true

      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

#
# ak-ecs Services
#
resource "aws_ecs_service" "nginx_service" {
  name            = "nginx-service"
  cluster         = aws_ecs_cluster.ak-ecs-task.id
  task_definition = aws_ecs_task_definition.nginx_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = ["subnet-073e5972c393a7107", "subnet-087e109d423293340"]  
    security_groups = [aws_security_group.ecs_tasks_sg.id]  
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ak-ecs-task.arn
    container_name   = "nginx"
    container_port   = 80
  }

}
