# modules/instances/variables.tf
variable "name" {
  type        = string
  description = "The name of the instances."
}

variable "ami" {
  type        = string
  description = "The ID of the AMI to use for the instances."
}

variable "instance_type" {
  type        = string
  description = "The type of instance to launch."
}

variable "counts" {
  type        = number
  description = "The number of instances to launch."
}

variable "security_group_id" {
  type        = string
  description = "The ID of the security group to associate with the instances."
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet to launch the instances in."
}

variable "root_volume_size" {
  type        = number
  description = "The size of the root volume in GB."
}

variable "root_volume_type" {
  type        = string
  description = "The type of root volume to use."
}

variable "ebs_volume_size" {
  type        = number
  description = "The size of the EBS volume in GB."
}

variable "ebs_volume_type" {
  type        = string
  description = "The type of EBS volume to use."
}




































/*variable "vpc_id" {
  type = string
  description = "VPC ID"
}

variable "cidr_block" {
  type = string
  description = "Subnet cidr block"
}

variable "ami" {
  type = string
  description = "AMI to use on the efsshare instance"
}

variable "efsshare_name" {
  type = string
  description = "Name of the efsshare"
}

variable "instance_type" {
  type = string
  description = "Instance type"
  default = "t3.micro"
}

variable "ins_key" {
  type = "string"
  description = "Name of the key to be used in SSH accessing"
  default = "000"
}*/


