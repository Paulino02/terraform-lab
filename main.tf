# Criação do ALB
resource "aws_lb" "my_lb" {
  name               = "my-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_http.id]
  subnets            = [aws_subnet.PublicSubnet.id]

  tags = {
    Name = "my-lb"
  }
}

# Criação do Target Group
resource "aws_lb_target_group" "my_target_group" {
  name     = "my-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.myvpc.id

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

# Criação do Listener
resource "aws_lb_listener" "my_listener" {
  load_balancer_arn = aws_lb.my_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }

  tags = {
    Name = "my-listener"
  }
}

