# Criação do Target Group
resource "aws_lb_target_group" "my_target_group" {
  name     = "my-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.myvpc.id
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "my-target-group"
  }
}