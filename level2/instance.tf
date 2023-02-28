
resource "aws_security_group" "public" {

  name   = "${var.env_code}-public-sec"
  vpc_id = data.terraform_remote_state.level1.outputs.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.public_ip}"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.public_ip}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.env_code}-public"
  }

}

resource "aws_instance" "private" {
  count = 2
  ami                         = data.aws_ami.amazonlinux.id
  instance_type               = "t3.micro"
  key_name                    = "public_key_ec2"
  vpc_security_group_ids      = [aws_security_group.private.id]
  subnet_id                   = data.terraform_remote_state.level1.outputs.private_subnet[count.index]
  user_data                   = file("user-data.sh")
  tags = {
    Name = "${var.env_code}-private-${count.index}"
  }
}




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
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
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

