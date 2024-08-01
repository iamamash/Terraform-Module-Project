module "vpc" {
  source        = "./vpc"
  vpc_name      = "zenskar-vpc"
  vpc_cidr      = "10.0.0.0/17"
  instance_type = "t2.micro"
  ami_id        = "ami-04a81a99f5ec58529"
  key_name      = module.ssh-key.key_name
}

module "ssh-key" {
  source   = "./ssh-keypair"
  key_name = "zenskar-key"
}



######################### Output Block ###############################

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_id" {
  value = module.vpc.public_subnet_id
}

output "ssh_private_key" {
  value     = module.ssh-key.ssh_private_key
  sensitive = false
}

output "private_instance_ip" {
  value = module.vpc.private_instance_ip
}

output "public_instance_ip" {
  value = module.vpc.public_instance_ip
}
