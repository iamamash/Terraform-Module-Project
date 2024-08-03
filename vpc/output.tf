# Output the VPC ID of the created VPC
output "vpc_id" {
  value = aws_vpc.main.id
}

# Output the Public Subnet ID of the created Subnet
output "public_subnet_id" {
  value = aws_subnet.public[*].id
}

output "private_subnet_id" {
  value = aws_subnet.private[*].id
}

output "private_instance_ip" {
  value = aws_instance.private[*].public_ip
}

output "public_instance_ip" {
  value = aws_instance.public.public_ip
}

output "private_sg_id" {
  value = aws_security_group.private_sg.id
}

output "private_instance_id" {
  value = aws_instance.private[*].id
}

output "private1_ip" {
  value = aws_instance.private[0].private_ip
}

output "private2_ip" {
  value = aws_instance.private[1].private_ip
}
