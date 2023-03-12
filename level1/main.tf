module "vpc" {
  source             = "../modules/vpc"
  public_cidr        = var.public_cidr
  private_cidr       = var.private_cidr
  availability_zones = var.availability_zones
  env_code           = var.env_code
  vpc_cidr           = var.vpc_cidr
}
  
