data "aws_ami" "amazonlinux1" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"]
}
module "service_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name                    = "${var.env_code}-asg"
  vpc_id                  = data.terraform_remote_state.level1.outputs.vpc_id
  tags                    = { Name = "${var.env_code}-asg" }

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      description = "https to ELB"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.vote_service_sg.security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1

}


module "autoscaling" {
  source = "terraform-aws-modules/autoscaling/aws"

  # insert the 9 required variables here
  desired_capacity    = 2
  health_check_type   = "EC2"
  image_id            = data.aws_ami.amazonlinux1.id
  instance_type       = "t2.micro"
  max_size            = 3
  min_size            = 1
  name                = "asg_module"
  user_data           = filebase64("user-data.sh")
  security_groups     = [module.service_sg.security_group_id]
  vpc_zone_identifier = data.terraform_remote_state.level1.outputs.private_subnet
  iam_role_policies   = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
  create_iam_instance_profile = true
  create                      = true
  iam_role_name               = "ec2-role"
  iam_role_path               = "/ec2/"
  target_group_arns           = module.alb.target_group_arns
  force_delete = true


}