terraform {
  required_version = ">=0.12" # ate least 0.12
}

# modules/instances/main.tf
resource "aws_instance" "web" {
  ami           = var.ami
  instance_type = var.instance_type
  count         = var.counts
  tags = {
    Name = var.name
  }
  key_name = "000"

  vpc_security_group_ids = [var.security_group_id]
  subnet_id              = var.subnet_id

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
  }

  ebs_block_device {
    device_name = "/dev/sdb"
    volume_size = var.ebs_volume_size
    volume_type = var.ebs_volume_type
  }
}

output "instance_ids" {
  value = aws_instance.web.*.id
}
