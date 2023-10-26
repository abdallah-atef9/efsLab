variable "image_id" {
  type = string
  description = "Image ID that will be used in auto-scalling"
}

variable "max_size" {
  type = string
}
variable "min_size" {
  type = string
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