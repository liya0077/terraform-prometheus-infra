# Application Load Balancer
resource "aws_lb" "prometheus_alb" {
  name               = "prometheus-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_az1.id, aws_subnet.public_az2.id]

  tags = {
    Name      = "prometheus - alb"
    Project   = "prometheus"
    ManagedBy = "terraform"
  }
}

# Target Group for Prometheus
resource "aws_lb_target_group" "prometheus_tg" {
  name     = "prometheus-tg"
  port     = 9090
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    port                = "9090"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
  }

  tags = {
    Name      = "prometheus - target-group"
    Project   = "prometheus"
    ManagedBy = "terraform"
  }
}

# ALB Listener
resource "aws_lb_listener" "prometheus_listener" {
  load_balancer_arn = aws_lb.prometheus_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prometheus_tg.arn
  }
}
