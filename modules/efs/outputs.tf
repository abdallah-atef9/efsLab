# modules/efs/outputs.tf
output efs_id_ {
    value       = aws_efs_file_system.efs.id
    description = "EFS ID"
}
