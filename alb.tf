resource "aws_lb" "ak-ecs-task" {
  name               = "ak-ecs-task-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = ["subnet-073e5972c393a7107", "subnet-087e109d423293340"] 
  idle_timeout       = 600

  tags = merge(tomap({ "Name" = "ak-ecs-task" }), local.ecs_cluster_tags)
}


resource "aws_lb_target_group" "ak-ecs-task" {
  name     = "ak-ecs-task-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.ak_ecs_vpc.id

  tags = merge(tomap({ "Name" = "ak-ecs-task" }), local.ecs_cluster_tags)
}

resource "aws_lb_listener" "ak-ecs-task" {
  load_balancer_arn = aws_lb.ak-ecs-task.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ak-ecs-task.arn

  }
}
