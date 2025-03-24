#### Security Group for the ALB ###########
###########################################

resource "aws_security_group" "alb_sg" {
  name        = "alb-security-group"
  description = "Security group for the ALB"
  vpc_id      = data.aws_vpc.ak_ecs_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  tags = merge(
    tomap({ "Name" = "ak-ecs-task" }),
    local.ecs_cluster_tags
  )
}

### Security Group for the ECS Tasks ####
#####################################


resource "aws_security_group" "ecs_tasks_sg" {
  name        = "ecs-tasks-security-group"
  description = "Security group for ECS tasks"
  vpc_id      = data.aws_vpc.ak_ecs_vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]  
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  tags = merge(
    tomap({ "Name" = "ak-ecs-task" }),
    local.ecs_cluster_tags
  )
}