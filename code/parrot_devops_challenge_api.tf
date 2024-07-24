# ECR Repository for Django Application
resource "aws_ecr_repository" "django" {
  name                 = "parrot-devops-challenge"
  image_tag_mutability = "MUTABLE"

  tags = {
    Name = "parrot-devops-challenge"
  }
}

# ECS Task Definition for Parrot DevOps Challenge API
resource "aws_ecs_task_definition" "parrot_devops_challenge" {
  family                   = "parrot-devops-challenge"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name  = "parrot-devops-challenge"
      image = "739696474668.dkr.ecr.us-west-2.amazonaws.com/parrot-devops-challenge:latest"
      essential = true
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "APP_VERSION"
          value = "0.1.0"
        },
        {
          name  = "POSTGRES_DB"
          value = "parrotdb"
        },
        {
          name  = "POSTGRES_HOST"
          value = "parrot-postgres.ckjrilljb4vq.us-west-2.rds.amazonaws.com"
        },
        {
          name  = "POSTGRES_PASSWORD"
          value = "parrotpassword"
        },
        {
          name  = "POSTGRES_PORT"
          value = "5432"
        },
        {
          name  = "POSTGRES_USER"
          value = "parrotuser"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"        = "/ecs/parrot-devops-challenge"
          "awslogs-region"       = "us-west-2"
          "awslogs-stream-prefix" = "ecs"
        }
      }
      command = ["python", "manage.py", "runserver", "0.0.0.0:8000"]
    }
  ])

  tags = {
    Name = "parrot-devops-challenge-task"
  }
}

# ECS Service for Parrot DevOps Challenge API
resource "aws_ecs_service" "parrot_devops_challenge" {
  name            = "parrot-devops-challenge-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.parrot_devops_challenge.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  lifecycle {
    ignore_changes = [task_definition]
  }

  network_configuration {
    subnets          = [aws_subnet.private.id, aws_subnet.private2.id]
    security_groups  = [aws_security_group.ecs_service.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.parrot_devops_challenge_lb.arn
    container_name   = "parrot-devops-challenge"
    container_port   = 8000
  }

  depends_on = [
    aws_lb_listener.main
  ]

  tags = {
    Name = "parrot-devops-challenge-service"
  }
}

# Load Balancer for Parrot DevOps Challenge API
resource "aws_lb" "parrot_devops_challenge_lb" {
  name               = "parrot-devops-challenge-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [aws_subnet.public.id, aws_subnet.public2.id]

  enable_deletion_protection = false

  tags = {
    Name = "parrot-devops-challenge-lb"
  }
}

# Target Group for Parrot DevOps Challenge API
resource "aws_lb_target_group" "parrot_devops_challenge_lb" {
  name     = "parrot-devops-challenge-tg"
  port     = 8000
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  target_type = "ip"

  health_check {
    interval            = 30
    path                = "/api/v1/counters/health"
    timeout             = 5
    unhealthy_threshold = 2
    healthy_threshold   = 2
    matcher             = "200"
  }

  tags = {
    Name = "parrot-devops-challenge-tg"
  }
}

# Listener for Parrot DevOps Challenge API Load Balancer
resource "aws_lb_listener" "parrot_devops_challenge_lb" {
  load_balancer_arn = aws_lb.parrot_devops_challenge_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.parrot_devops_challenge_lb.arn
  }

  tags = {
    Name = "parrot-devops-challenge-listener"
  }
}

# CloudWatch Log Group for ECS
resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/parrot-devops-challenge"
  retention_in_days = 7
}
