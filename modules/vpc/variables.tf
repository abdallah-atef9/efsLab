

# modules/vpc/variables.tf
variable "name" {
  type        = string
  description = "The name of the VPC."
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
