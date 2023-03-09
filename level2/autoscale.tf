resource "aws_launch_configuration" "main" {
  image_id        = data.aws_ami.amazonlinux.id
  instance_type   = "t3.micro"
  name_prefix     = var.env_code
  key_name        = "public_key_ec2"
  user_data       = file("user-data.sh")
  security_groups = [aws_security_group.private.id]
  iam_instance_profile = aws_iam_instance_profile.main.name
}

resource "aws_autoscaling_group" "main" {
  name                 = var.env_code
  min_size             = 1
  desired_capacity     = 1
  max_size             = 4
  target_group_arns    = [aws_alb_target_group.group.arn]
  launch_configuration = aws_launch_configuration.main.name
  vpc_zone_identifier  = data.terraform_remote_state.level1.outputs.private_subnet

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = var.env_code
  }
}
