/*output "instance" {
  value = aws_instance.efsshare
  description = "efsshare contents"
}*/

# modules/instances/outputs.tf
output "instance_ids_" {
  value       = aws_instance.web.*.id
  description = "A list of IDs for the instances."
}

output "instance_id" {
  value = aws_instance.web.id
}
