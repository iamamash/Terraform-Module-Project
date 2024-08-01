data "local_file" "ssh_private_key" {
  filename = "C:/Users/ansar/.ssh/id_rsa"
}

output "ssh_private_key" {
  value     = data.local_file.ssh_private_key.content
  sensitive = false
}

output "key_name" {
  value = aws_key_pair.key.key_name
}
