terraform {
  required_version = ">=0.12" # ate least 0.12
}

#  -------------------------------------------------------------------
resource "aws_security_group" "sg" {
  name_prefix = var.prefix_name
  vpc_id = var.vpc_id
}


