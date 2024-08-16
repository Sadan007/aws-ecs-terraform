resource "aws_security_group" "alb" {
  name        = "${local.app}-app"
  description = "controls access to the ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow HTTP from all"
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.app}-alb"
  }
}

resource "aws_security_group" "ecs" {
  name        = "${local.app}-ecs"
  description = "allows for ecs"
  vpc_id      = module.vpc.vpc_id

  egress {
    description = "Allow all outbound"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.app}-ecs"
  }
}

resource "aws_security_group_rule" "ecs_from_alb" {
  description              = "Allow 8080 from security group for ALB"
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id
  security_group_id        = aws_security_group.ecs.id
}