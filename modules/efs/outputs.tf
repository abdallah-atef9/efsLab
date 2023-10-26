# modules/efs/outputs.tf
output efs_id_ {
    value       = aws_efs_file_system.efs.id
    description = "EFS ID"
}
output "efs_id" {
  value       = aws_efs_file_system.efs.id
  description = "The ID of the EFS file system."
}

output "mount_target_dns_names" {
  value       = aws_efs_mount_target.mount_target.*.dns_name
  description = "A list of DNS names for the mount targets."
}
