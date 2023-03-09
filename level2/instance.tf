resource "aws_security_group" "private" {

  name   = "${var.env_code}-private-sec"
  vpc_id = data.terraform_remote_state.level1.outputs.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.level1.outputs.vpc_cidr]
  }
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sec_gpe.id]
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

resource "aws_security_group" "public" {

  name   = "${var.env_code}-public-sec"
  vpc_id = data.terraform_remote_state.level1.outputs.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["80.215.162.233/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }



  tags = {
    Name = "${var.env_code}-public_bastion"
  }
}

resource "aws_instance" "public_instance" {
  availability_zone = data.aws_availability_zones.available.names[0]
  ami = data.aws_ami.amazonlinux.id
  subnet_id = data.terraform_remote_state.level1.outputs.public_subnet[0]
  security_groups = [aws_security_group.public.id]
  associate_public_ip_address = true
  instance_type = "t3.micro"
  key_name = "public_key_ec2"
  tags = {
    Name = "bastion"
  }
  iam_instance_profile = aws_iam_instance_profile.main.name



}
