variable "image_id" {
  type = string
  description = "Image ID that will be used in auto-scalling"
}
variable "instance_type" {
  type = string
}
variable "key_name" {
  type = string
}
variable "max_size" {
  type = number
  default = 5
}
variable "min_size" {
  type = number
  default = 2
}
variable "security_group" {
  type = list(string)
}
variable "subnet_id" {
  type = string
}
variable "az" {
  type = string
}
variable "ebs_volume_size" {
  type = number
}
variable "subnet_1" {
  type = string
}
variable "subnet_2" {
  type = string
}
variable "lba" {
  type = string
}