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

module "load-balancer" {
  source              = "./load-balancer"
  alb_name            = "private-alb"
  alb_type            = "application"
  private_sg_id       = module.vpc.private_sg_id
  private_subnet_id   = module.vpc.private_subnet_id
  vpc_id              = module.vpc.vpc_id
  private_instance_id = module.vpc.private_instance_id
}

module "api-gateway" {
  source           = "./api-gateway"
  api_gateway_name = "nginx-api"
  dns_name         = module.load-balancer.dns_name
}

######################### Output Block ###############################

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_id" {
  value = module.vpc.public_subnet_id
}

output "private_subnet_id" {
  value = module.vpc.private_subnet_id
}

output "private_sg_id" {
  value = module.vpc.private_sg_id
}

output "private_instance_id" {
  value = module.vpc.private_instance_id
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

output "dns_name" {
  value = module.load-balancer.dns_name
}

output "private1_ip" {
  value = module.vpc.private1_ip
}

output "private2_ip" {
  value = module.vpc.private2_ip
}
