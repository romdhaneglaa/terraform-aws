module "rds" {
  source = "../modules/rds"
  env_code = var.env_code
  vpc_id = data.terraform_remote_state.level1.outputs.vpc_id
  subnet_id = data.terraform_remote_state.level1.outputs.private_subnet
  db_name = "mydb"
  db_psw = "adminadmin"
  db_user = "admin"
  secutiry_group = module.asg.instance_sec_gpe
}
