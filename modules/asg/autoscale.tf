resource "aws_launch_configuration" "main" {
  image_id             = data.aws_ami.amazonlinux.id
  instance_type        = "t3.micro"
  name_prefix          = var.env_code
  user_data            = file("user-data.sh")
  security_groups      = [aws_security_group.private.id]
  iam_instance_profile = aws_iam_instance_profile.main.name
}

resource "aws_autoscaling_group" "main" {
  name                 = var.env_code
  min_size             = 1
  desired_capacity     = 1
  max_size             = 4
  target_group_arns    = [var.target_group_arns]
  launch_configuration = aws_launch_configuration.main.name
  vpc_zone_identifier  = var.aws_autoscaling_group_subnet_id

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = var.env_code
  }
}
resource "aws_security_group" "private" {

  name   = "${var.env_code}-private-sec"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.lb_security_groups]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.env_code}-private"
  }
}


