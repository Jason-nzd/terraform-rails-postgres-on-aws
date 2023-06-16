output "db_endpoint" {
  description = "Endpoint for the DB Server"
  value       = aws_db_instance.postgres.endpoint
}

output "ec2_http_address" {
  description = "Public http address of the EC2 instance"
  value       = "http://${aws_instance.ec2_server.public_dns}"
}

output "ec2_scp_cloud_init_log" {
  description = "SCP command to copy the remote cloud-init-output.log"
  value       = "scp -i ${var.ssh_key_local_path}${var.ssh_key_name}.pem ec2-user@${aws_instance.ec2_server.public_ip}:/var/log/cloud-init-output.log . && code cloud-init-output.log"
}

output "ec2_ssh_command" {
  description = "SSH command for connecting to EC2 instance"
  value       = "ssh -i ${var.ssh_key_local_path}${var.ssh_key_name}.pem ec2-user@${aws_instance.ec2_server.public_ip}"
}
