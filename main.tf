module "vpc" {
  source = "./modules/vpc"
}

module "ec2" {
  source                        = "./modules/ec2"
  common_vpc_security_group     = module.vpc.common_vpc_security_group
  public_subnet_ec2             = module.vpc.public_subnet_ec2
}

module "rds" {
  source                        = "./modules/rds"
  common_vpc_security_group     = module.vpc.common_vpc_security_group
  db_subnet_group               = module.vpc.db_subnet_group
}
