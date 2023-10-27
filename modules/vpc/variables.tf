

# modules/vpc/variables.tf
variable "name" {
  type        = string
  description = "The name of the VPC."
}
variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}
variable "cidr_block" {
  type        = string
  description = "The CIDR block for the VPC."
}

variable "public_subnets" {
  type        = list(string)
  description = "A list of public subnet CIDR blocks."
}

variable "private_subnets" {
  type        = list(string)
  description = "A list of private subnet CIDR blocks."
}
