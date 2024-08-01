variable "vpc_name" {
  description = "Name of VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "List of availability zones for the region"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "key_name" {
  description = "ssh-keyname from module"
  type        = string
}

####################### Instance Provisioning ############################

variable "ami_id" {
  description = "AMI ID for the instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type"
  type        = string
}
