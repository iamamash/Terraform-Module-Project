resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public" {
  count                   = 3
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subent-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count             = 3
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + 3)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "private-subent-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "public_a" {
  count          = 3
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  count      = 3
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_nat_gateway" "gw" {
  count         = 3
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = element(aws_subnet.public[*].id, count.index)
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.gw[*].id, 0)
  }
}

resource "aws_route_table_association" "private_a" {
  count          = 3
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private.id
}



####################### Instance Provisioning ############################

resource "aws_instance" "private" {
  count           = 2
  ami             = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = element(aws_subnet.private[*].id, count.index)
  key_name        = var.key_name
  security_groups = [aws_security_group.private_sg.id]

  tags = {
    Name = "private-instance-${count.index + 1}"
  }
}

resource "aws_instance" "public" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = element(aws_subnet.public[*].id, 0)
  key_name        = var.key_name
  security_groups = [aws_security_group.public_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    export PRIVATE_IP1="${aws_instance.private[0].private_ip}"
    export PRIVATE_IP2="${aws_instance.private[1].private_ip}"

    sudo apt-get update -y
    sudo apt-get install software-properties-common -y
    sudo add-apt-repository --yes --update ppa:ansible/ansible -y
    sudo apt-get install ansible -y

    bash -c "$(cat <<'EOT'
      # Your script content here
      cat <<EOT > /home/ubuntu/inventory
      [private]
      private1 ansible_host=$PRIVATE_IP1
      private2 ansible_host=$PRIVATE_IP2

      [private:vars]
      ansible_python_interpreter=/usr/bin/python3
      ansible_user=ubuntu
      ansible_ssh_private_key_file=/home/ubuntu/id_rsa
      EOT
    EOT
    )"

    sudo chmod 400 /home/ubuntu/id_rsa
    sudo chown ubuntu:ubuntu /home/ubuntu/inventory
  EOF

  provisioner "file" {
    source      = "~/.ssh/id_rsa"
    destination = "/home/ubuntu/id_rsa"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
  }

  provisioner "file" {
    source      = "D:/DevOps/Projects/Terraform-Module-Project/ansible/playbook.yaml"
    destination = "/home/ubuntu/playbook.yaml"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
  }

  tags = {
    Name = "public-instance"
  }

  depends_on = [aws_instance.private]
}

resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private-sg"
  }
}

resource "aws_security_group" "public_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "public-sg"
  }
}

