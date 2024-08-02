variable "alb_name" {
  description = "ALB name"
  type        = string
}

variable "alb_type" {
  description = "Type of ALB"
  type        = string
}

variable "private_sg_id" {
  description = "Private security group ID"
  type        = string
}

variable "private_subnet_id" {
  description = "Private subnet ID"
  type        = list(string)
}

variable "private_instance_id" {
  description = "Private instance ID"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
