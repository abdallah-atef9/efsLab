resource "aws_launch_template" "foo" {
  name = "autoscaling-tpl"
  image_id = var.image_id
  instance_type = "t3.micro"
  key_name = "000"
  user_data = filebase64("${path.module}/ec2-init.sh")
  vpc_security_group_ids = var.security_group ## attach to this variable "[module.nfs_server_sg.sg_id]"

  network_interfaces {
    subnet_id = var.subnet_id
    associate_public_ip_address = true
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

/*

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  cpu_options {
    core_count       = 4
    threads_per_core = 2
  }

  credit_specification {
    cpu_credits = "standard"
  }

  disable_api_stop        = true
  disable_api_termination = true

  ebs_optimized = true

  elastic_gpu_specifications {
    type = "test"
  }

  elastic_inference_accelerator {
    type = "eia1.medium"
  }

  iam_instance_profile {
    name = "test"
  }


  instance_initiated_shutdown_behavior = "terminate"

  instance_market_options {
    market_type = "spot"
  }


  kernel_id = "test"

 

  license_specification {
    license_configuration_arn = "arn:aws:license-manager:eu-west-1:123456789012:license-configuration:lic-0123456789abcdef0123456789abcdef"
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = true
  }

  placement {
    availability_zone = "us-west-2a"
  }

  ram_disk_id = "test"

  vpc_security_group_ids = ["sg-12345678"]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "test"
    }
  }
*/
}


/*
resource "aws_autoscalling_group" "this" {
    name = "autoscalling- asg"
    max_size = var.max_size
    min_size = var.min_size
    desired_capacity = 
}
*/
