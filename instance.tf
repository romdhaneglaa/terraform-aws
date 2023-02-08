
resource "aws_security_group" "public" {

  name   = "${var.env_code}-public-sec"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
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


resource "aws_instance" "public" {
  ami                         = "ami-0cff7528ff583bf9a"
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  key_name                    = "public_key_ec2"
  vpc_security_group_ids      = [aws_security_group.public.id]
  subnet_id                   = aws_subnet.public_subnet[0].id
  tags                        = {
    Name = "${var.env_code}-public"
  }
}

  resource "aws_security_group" "private" {

    name   = "${var.env_code}-private-sec"
    vpc_id = aws_vpc.main.id

    ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["${var.vpc_cidr}"]
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


  resource "aws_instance" "private" {
    ami                         = "ami-0cff7528ff583bf9a"
    instance_type               = "t3.micro"
    associate_public_ip_address = true
    key_name                    = "public_key_ec2"
    vpc_security_group_ids      = [aws_security_group.private.id]
    subnet_id                   = aws_subnet.private_subnet[0].id
    tags = {
      Name = "${var.env_code}-private"
    }

}