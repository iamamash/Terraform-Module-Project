output "alb_name" {
  value = aws_lb.private_alb.name
}

output "dns_name" {
  value = aws_lb.private_alb.dns_name
}
