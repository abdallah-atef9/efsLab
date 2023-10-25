terraform {
  required_version = ">=0.12" # ate least 0.12
}
# modules/efs/main.tf
resource "aws_efs_file_system" "efs" {
  creation_token = var.creation_token
  encrypted      = var.encrypted

  tags = {
    Name = var.name
  }

  provisioned_throughput_in_mibps = var.provisioned_throughput_in_mibps
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
  security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_security_group" "efs_sg" {
  # name_prefix   = var.name_prefix
  name_prefix = "sg_"
  vpc_id        = var.vpc_id

  ingress {
    from_port   = var.nfs_port
    to_port     = var.nfs_port
    protocol    = var.nfs_protocol
    cidr_blocks = [var.nfs_cidr_block]
  }

  egress {
    from_port   = var.all_traffic_from_port
    to_port     = var.all_traffic_to_port
    protocol    = var.all_traffic_protocol
    cidr_blocks = [var.all_traffic_cidr_block]
  }
}

output "efs_id" {
  value       = aws_efs_file_system.efs.id
  description = "The ID of the EFS file system."
}

output "mount_target_dns_names" {
  value       = aws_efs_mount_target.mount_target.*.dns_name
  description = "A list of DNS names for the mount targets."
}


/*resource "aws_efs_file_system" "efs" {
  creation_token = var.creation_token
  performance_mode = var.performance_mode
  throughput_mode = var.throughput_mode
  encrypted = var.enc
  tags = {
    Name = var.creation_token
  }
}

resource "aws_efs_mount_target" "mount_target_1" {
  file_system_id = aws_efs_file_system.efs.id
  subnet_id = aws_subnet.subnet_1.id
  security_groups = [aws_security_group.sg.id]
}

resource "aws_efs_mount_target" "mount_target_2" {
  file_system_id = aws_efs_file_system.efs.id
  subnet_id = aws_subnet.subnet_2.id
  security_groups = [aws_security_group.sg.id]
}*/