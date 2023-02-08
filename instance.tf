resource "aws_instance" "public" {
  ami           = "ami-005e54dee72cc1d00" # us-west-2
  instance_type = "t3.micro"
  associate_public_ip_address = true
  key_name = "public_key_ec2"
  vpc_security_group_ids = []
  subnet_id = aws_subnet
  tags = {
    Name = "ec2-intance-public"
  }

}