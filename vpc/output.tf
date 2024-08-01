# Output the VPC ID of the created VPC
output "vpc_id" {
  value = aws_vpc.main.id
}

# Output the Public Subnet ID of the created Subnet
output "public_subnet_id" {
  value = aws_subnet.public[*].id
}

output "private_instance_ip" {
  value = aws_instance.private[*].public_ip
}

output "public_instance_ip" {
  value = aws_instance.public.public_ip
}
