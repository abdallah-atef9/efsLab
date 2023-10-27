# terraform {
#   required_version = ">=0.12" # ate least 0.12
# }
# modules/efs/main.tf
resource "aws_efs_file_system" "efs" {
  creation_token = var.creation_token
  encrypted      = var.encrypted

  tags = {
    Name = var.name
  }

  # provisioned_throughput_in_mibps = var.provisioned_throughput_in_mibps
  performance_mode                = var.performance_mode
  throughput_mode                 = var.throughput_mode

  lifecycle_policy {
    transition_to_ia = var.transition_to_ia
  }
}

resource "aws_efs_mount_target" "mount_target" {
  count           = length(var.subnet_ids)
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = var.subnet_ids[count.index]
  security_groups = [module.nfs_sg.sg_id]
}
module "nfs_sg" {
  source = "../sg"
  prefix_name = "sg_"
  vpc_id = var.vpc_id
}

module "nfs_ingress_sg_rule" {
  source = "../sg_rule"
  sg_rule_type = "ingress"
  sg_id = module.nfs_sg.sg_id ## a variable in security group created in the module
  from_port = var.nfs_port
  to_port = var.nfs_port
  protocol = var.nfs_protocol
  cidr_block = var.nfs_cidr_block
}

module "nfs_egress_sg_rule" {
  source = "../sg_rule"
  sg_rule_type = "egress"
  sg_id = module.nfs_sg.sg_id ## a variable in security group created in the module
  from_port = var.all_traffic_from_port
  to_port = var.all_traffic_to_port
  protocol = var.all_traffic_protocol
  cidr_block = var.all_traffic_cidr_block
}