data "terraform_remote_state" "vpcId" {
  backend = "s3"
  config  = {
    bucket = "aws-terraform-state-romdhan"
    key    = "leve1.tfstate"
    region = "us-east-1"
  }
}
data "aws_route53_zone" "main" {
  name = "bagbaga-glaa.click"
}
module "vote_service_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name                    = "${var.env_code}-loadbalacer"
  vpc_id                  = data.terraform_remote_state.level1.outputs.vpc_id
  tags                    = { Name = "${var.env_code}-private-lb-sec-gpe" }
  egress_cidr_blocks      = ["0.0.0.0/0"]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  ingress_with_cidr_blocks = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },

  ]

}

module "route53" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "2.10.2"

  records = [
    {
      name    = "2048"
      type    = "CNAME"
      ttl     = 3600
      records = [module.alb.lb_dns_name]
    }
  ]
  zone_id = data.aws_route53_zone.main.zone_id
}


module "acm" {
  source            = "terraform-aws-modules/acm/aws"
  version           = "4.3.2"
  domain_name       = "2048.bagbaga-glaa.click"
  validation_method = "DNS"
  zone_id           = data.aws_route53_zone.main.zone_id
  tags              = {
    Name = var.env_code
  }
  wait_for_validation = true
}


module "alb" {
  name               = "alb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [module.vote_service_sg.security_group_id]
  subnets            = data.terraform_remote_state.level1.outputs.public_subnet
  vpc_id             = data.terraform_remote_state.level1.outputs.vpc_id
  source             = "terraform-aws-modules/alb/aws"
  version            = "8.6.0"
  https_listeners    = [
    {
      port               = "443"
      protocol           = "HTTPS"
      certificate_arn    = module.acm.acm_certificate_arn
      ssl_policy         = "ELBSecurityPolicy-2016-08"
      action_type        = "forward"
      target_group_index = 0
    }
  ]
  target_groups = [
    {
      name             = "lbtargetgroup"
      backend_port     = "80"
      backend_protocol = "HTTP"
      health_check     = {
        enabled             = true
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 2
        interval            = 5
        matcher             = 200
      }
    }
  ]


}