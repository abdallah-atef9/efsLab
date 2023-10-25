# modules/efs/variables.tf
variable "name" {
  type        = string
  description = "The name of the EFS file system."
}

# variable "name_prefix" {
#   type        = string
#   description = "The name of the EFS file system."
# }

variable "creation_token" {
  type        = string
  description = "A unique name for the EFS file system."
}

variable "encrypted" {
  type        = bool
  description = "Whether to enable encryption for the EFS file system."
}

variable "provisioned_throughput_in_mibps" {
  type        = number
  description = "The throughput, measured in MiB/s, that you want to provision for the file system."
}

variable "performance_mode" {
  type        = string
  description = "The performance mode of the file system."
}

variable "throughput_mode" {
  type        = string
  description = "The throughput mode of the file system."
}

variable "transition_to_ia" {
  type        = string
  description = "The lifecycle policy for the file system."
}

variable "subnet_ids" {
  type        = list(string)
  description = "A list of subnet IDs in which to create mount targets."
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC in which to create security groups."
}

variable "nfs_port" {
  type        = number
  description = "The port number for NFS traffic."
}

variable "nfs_protocol" {
  type        = string
  description = "The protocol used for NFS traffic."
}

variable "nfs_cidr_block" {
  type        = string
  description = "The CIDR block from which to allow NFS traffic."
}

variable "all_traffic_from_port" {
  type        = number
  description = "The starting port number for all traffic."
}

variable "all_traffic_to_port" {
  type        = number
  description = "The ending port number for all traffic."
}

variable "all_traffic_protocol" {
  type        = string
  description = "The protocol used for all traffic."
}

variable "all_traffic_cidr_block" {
  type        = string
}
