resource "aws_ecs_cluster" "my_cluster" {
  name = "my-cluster"
}


### 5. Definição da Task Definition

Defina uma task definition que usará a imagem do ECR:

data "aws_ecr_authorization_token" "auth" {}

resource "aws_ecs_task_definition" "my_task" {
  family                = "my-task"
  network_mode          = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                   = "256"
  memory                = "512"

  container_definitions = <<DEFINITION
[
  {
    "name": "my-container",
    "image": "${aws_ecr_repository.my_repo.repository_url}:latest",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  }
]
DEFINITION
}

### 6. Criação do Service ECS

Crie um serviço ECS que use a task definition:

resource "aws_ecs_service" "my_service" {
  name            = "my-service"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.my_task.arn
  desired_count   = 1

  launch_type = "FARGATE"

  network_configuration {
    subnets = ["subnet-12345678"]
    security_groups = ["sg-12345678"]
    assign_public_ip = true
  }
}