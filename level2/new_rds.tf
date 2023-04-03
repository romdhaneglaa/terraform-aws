module "rds_sec_gpe" {

  source = "terraform-aws-modules/security-group/aws"
  vpc_id = data.terraform_remote_state.level1.outputs.vpc_id
#  ingress_cidr_blocks = [{
#    from_port = 3306
#    to_port   = 3306
#    protocol  = "tcp"
#    security_groups = [module.service_sg.security_group_id]
#  }]

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = module.service_sg.security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1
  name = "rds_sec_gpe"

  tags = {
    Name = "${var.env_code}"
  }

}


module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "5.6.0"
  # insert the 1 required variable here

  identifier = var.env_code
  db_name = var.env_code
  engine = "mysql"
  instance_class = "db.t3.micro"
  allocated_storage = 10
  username = "admin"
  password = jsondecode(data.aws_secretsmanager_secret_version.version.secret_string)["password"]
  multi_az = true
  subnet_ids = data.terraform_remote_state.level1.outputs.private_subnet
  vpc_security_group_ids = [module.rds_sec_gpe.security_group_id]
  skip_final_snapshot = true
  create_random_password = false
  port = 3306
  create_db_subnet_group = true
  family = "mysql5.7"
  engine_version         = "5.7"
  major_engine_version = "5.7"
}
