variable "vpc_id" {
  type = string
}

variable "sg_id" {
  type = string
}
variable "subnets" {
  type = list(string)
}
variable "internal" {
  type = bool
}
variable "lb_type" {
  type = string
}
variable "instance_1_id" {
  type = string
}
variable "instance_2_id" {
  type = string
}
/*
variable "cider_block" {
    type = string
}

variable "sg_id" {
  type = string
  description = "security group id that will add the rule to specific security group using security group id you pass to it"
}
variable "sg_rule_type" {
  type = string
  description = "The type of the security group rule which is: ingress or egress."
}
variable "from_port" {
  type = number
  description = "the port from it you want from 22 to 22 if you want only allow SSH ot from 0 to 65535 if all traffic wanted."
}
variable "to_port" {
  type = number
  description = "the port to it you want from 22 to 22 if you want only allow SSH ot from 0 to 65535 if all traffic wanted."
}
variable "protocol" {
  type = string
}
variable "cidr_block" {
  type = string
}
*/