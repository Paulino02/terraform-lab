resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action    = "sts:AssumeRole"
      }
    ]
  })

  inline_policy {
    name = "ECRPolicy"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Effect    = "Allow",
          Action    = [
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "ecr:BatchCheckLayerAvailability"
          ],
          Resource  = "*"
        }
      ]
    })
  }
  tags = {
  Name = "ECS Task Execution Role"
}
}