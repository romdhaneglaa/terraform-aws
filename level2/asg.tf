module "asg" {
  source                          = "../modules/asg"
  env_code                        = var.env_code
  aws_autoscaling_group_subnet_id = data.terraform_remote_state.level1.outputs.private_subnet
  vpc_id                          = data.terraform_remote_state.level1.outputs.vpc_id
  lb_security_groups              = module.lb.lb_security_groups
  target_group_arns               = module.lb.target_group_arns
}

