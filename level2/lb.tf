module "lb" {
  source     = "../modules/lb"
  env_code   = var.env_code
  lb_subnets = data.terraform_remote_state.level1.outputs.public_subnet
  vpc_id     = data.terraform_remote_state.level1.outputs.vpc_id
}
  
