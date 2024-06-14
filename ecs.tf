resource "aws_ecs_cluster" "my_cluster" {
  name = "my-cluster"
}

# Definição da Task Definition no ECS

data "aws_ecr_authorization_token" "auth" {}

resource "aws_ecs_task_definition" "my_task" {
  family                = "my-task"
  network_mode          = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                   = "256"
  memory                = "512"

  execution_role_arn     = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn          = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = <<DEFINITION
[
  {
    "name": "my-container-api",
    "image": "${aws_ecr_repository.repo.repository_url}:latest",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 8080,
        "hostPort": 8080
      }
    ]
  }
]
DEFINITION
}

# Criação do Service ECS

resource "aws_ecs_service" "my_service" {
  name            = "my-service"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.my_task.arn
  desired_count   = 1
  launch_type = "FARGATE"

  network_configuration {
    subnets = [aws_subnet.PublicSubnet1.id]
    security_groups = [aws_security_group.allow_http.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.my_target_group.arn
    container_name   = "my-container-api"
    container_port   = 8080
  }

  depends_on = [aws_lb_listener.my_listener]
}

# Outputs
output "alb_dns_name" {
  value = aws_lb.my_lb.dns_name
}


