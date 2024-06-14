# Criação do ALB
resource "aws_lb" "my_lb" {
  name               = "my-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_http.id]
  subnets            = [aws_subnet.PublicSubnet1.id, aws_subnet.PublicSubnet2.id]

  tags = {
    Name = "my-lb"
  }
}