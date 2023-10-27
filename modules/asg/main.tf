data "template_file" "instances_user_data" {
  template = <<-EOF
    #!/bin/bash
    sudo mkdir /mnt/elfate7
    sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport 10.0.4.33:/ /mnt/elfate7
  EOF
}
resource "aws_launch_template" "foo" {
  name = "autoscaling_tpl"
  image_id = var.image_id
  instance_type = var.instance_type
  key_name = var.key_name
  user_data = base64encode(data.template_file.instances_user_data.rendered)
  # user_data = filebase64("${path.module}/ec2-init.sh")
  # vpc_security_group_ids = var.security_group ## attach to this variable "[module.nfs_server_sg.sg_id]"

  network_interfaces {
    subnet_id = var.subnet_id
    associate_public_ip_address = true
    security_groups = var.security_group
  }

  placement {
  availability_zone = var.az
  }

  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size = var.ebs_volume_size
    }
  }
}

resource "aws_autoscaling_group" "Web-Store-ASG" {
  max_size            = var.max_size
  min_size            = var.min_size
  desired_capacity    = 2
  health_check_type   = "ELB"
  target_group_arns = [var.lba]
  vpc_zone_identifier = [var.subnet_1, var.subnet_2]
  launch_template {
    id      = aws_launch_template.foo.id
    version = "$Latest"
  }
}
