resource "aws_lb" "lb_app" {
  name               = "lb-tf-application"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sec_gpe.id]
  subnets            = var.lb_subnets
}

resource "aws_security_group" "lb_sec_gpe" {

  name   = "${var.env_code}-loadbalacer"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.env_code}-private-lb-sec-gpe"
  }

}


resource "aws_alb_target_group" "group" {
  name     = "terraform-alb-target"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    path                = "/"
    port                = 80
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 5
    matcher             = 200
  }
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.lb_app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.group.arn

  }

}


