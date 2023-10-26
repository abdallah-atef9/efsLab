terraform {
  required_version = ">=0.12" # ate least 0.12
}

module "vpc" {
  source          = "./modules/vpc"
  name            = "my-vpc"
  cidr_block      = "10.0.0.0/16"
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
}
/*
    Creating Security group and rules for VPC General usage
*/

module "nfs_server_sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
  prefix_name = "nfs_sg_"
}
module "nfs_ingress_2049_vpc" {
  source = "./modules/sg_rule"
  sg_id = module.nfs_server_sg.sg_id
  sg_rule_type = "ingress"
  from_port = 2049
  to_port = 2049
  protocol = "tcp"
  cidr_block = module.vpc.vpc_cidrblock
}
module "nfs_egress_all_traffic" {
  source = "./modules/sg_rule"
  sg_id = module.nfs_server_sg.sg_id
  sg_rule_type = "egress"
  from_port = 0
  to_port = 65535
  protocol = "tcp"
  cidr_block = "0.0.0.0/0"
}
module "nfs_ingress_2049_10" {
  source = "./modules/sg_rule"
  sg_id = module.nfs_server_sg.sg_id
  sg_rule_type = "ingress"
  from_port = 2049
  to_port = 2049
  protocol = "tcp"
  cidr_block = "10.0.0.0/8"
}
module "nfs_egress_2049_10" {
  source = "./modules/sg_rule"
  sg_id = module.nfs_server_sg.sg_id
  sg_rule_type = "egress"
  from_port = 2049
  to_port = 2049
  protocol = "tcp"
  cidr_block = "10.0.0.0/8"
}
module "nfs_ingress_22_10" {
  source = "./modules/sg_rule"
  sg_id = module.nfs_server_sg.sg_id
  sg_rule_type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_block = "10.0.0.0/8"
}
module "nfs_egress_22_10" {
  source = "./modules/sg_rule"
  sg_id = module.nfs_server_sg.sg_id
  sg_rule_type = "egress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_block = "0.0.0.0/0"
}

/*
    Creating Security group and rules for Application Load Balancer
*/
module "alp_sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
  prefix_name = "alp_sg_"
}
module "ingress_ssh" {
  source = "./modules/sg_rule"
  sg_id = module.alp_sg.sg_id ## a variable in security group created in the module
  sg_rule_type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_block = "0.0.0.0/0"
}
module "ingress_https" {
  source = "./modules/sg_rule"
  sg_id = module.alp_sg.sg_id ## a variable in security group created in the module
  sg_rule_type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_block = "0.0.0.0/0"
}
module "ingress_http" {
  source = "./modules/sg_rule"
  sg_id = module.alp_sg.sg_id ## a variable in security group created in the module
  sg_rule_type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_block = "0.0.0.0/0"
}
module "egress_all_traffic" {
  source = "./modules/sg_rule"
  sg_id = module.alp_sg.sg_id ## a variable in security group created in the module
  sg_rule_type = "ingress"
  from_port = 0
  to_port = 65535
  protocol = "tcp"
  cidr_block = "0.0.0.0/0"
}

## Creating EFS
module "efs" {
  source = "./modules/efs"
  name = "abu-aubayda"
  creation_token = "my-efs-token"
  encrypted = true
  provisioned_throughput_in_mibps = 1024
  performance_mode = "maxIO"
  throughput_mode = "provisioned"
  transition_to_ia = "AFTER_30_DAYS"
  subnet_ids = [module.vpc.private_subnet_ids[0], module.vpc.private_subnet_ids[1]]
  vpc_id = module.vpc.vpc_id
  nfs_port = 2049
  nfs_protocol = "tcp"
  nfs_cidr_block = "10.0.0.0/8"
  all_traffic_from_port = 0
  all_traffic_to_port = 65535
  all_traffic_protocol = "tcp"
  all_traffic_cidr_block = "10.0.0.0/8"
}

module "instance_1" {
  source = "./modules/instances"
  name = "instance-1"
  ami = "ami-0550c2ee59485be53"
  instance_type = "t3.micro"
  # counts = 1
  subnet_id = module.vpc.private_subnet_ids[0]
  # subnet_id = module.vpc.private_subnets[1]
  root_volume_size  = 16 # increasing volume from 8 --> 16 GB
  root_volume_type  = "gp2"
  ebs_volume_size   = 20
  ebs_volume_type   = "gp2"
  security_group_id = module.nfs_server_sg.sg_id
}

module "instance_2" {
  source = "./modules/instances"
  name = "instance-2"
  ami = "ami-0550c2ee59485be53"
  instance_type = "t3.micro"
  # counts = 1
  subnet_id = module.vpc.private_subnet_ids[1]
  root_volume_size  = 16 # increasing volume from 8 --> 16 GB
  root_volume_type  = "gp2"
  ebs_volume_size   = 20
  ebs_volume_type   = "gp2"
  # security_group_id = module.security_group.nfs_server_sg.id
  security_group_id = module.nfs_server_sg.sg_id
}

module "application_load_balancer" {
  source = "./modules/alp"
  vpc_id = module.vpc.vpc_id # for target group
  sg_id = module.alp_sg.sg_id 
  subnets = module.vpc.private_subnet_ids
  internal = false
  lb_type = "application"
  instance_1_id = module.instance_1.instance_id
  instance_2_id = module.instance_2.instance_id
}

module "bkp" {
  source = "./modules/backup"
  instance_1_id = [module.instance_1.instance_id]
  instance_2_id = [module.instance_2.instance_id]
}
