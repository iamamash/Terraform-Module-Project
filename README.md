# Terraform-Module-Project
# API Gateway and Nginx Deployment

## Project Overview

This project demonstrates the setup and deployment of an API Gateway that routes requests to an Application Load Balancer (ALB), which forwards traffic to Nginx instances. The infrastructure is provisioned using Terraform, and Nginx and Docker are installed on private EC2 instances using Ansible.

**Security and Network Configuration**:
- **VPC Setup**: The infrastructure is deployed within a Virtual Private Cloud (VPC) to ensure isolation and security.
- **Private and Public Subnets**: The VPC includes both private and public subnets. Private subnets are used for EC2 instances, while public subnets are used for NAT and Internet Gateway.
- **NAT Gateway**: A NAT Gateway allows private subnet instances to access the internet securely while keeping them inaccessible from external sources.
- **Internet Gateway**: An Internet Gateway is configured for the public subnet to enable outbound internet access.
- **Route Tables**: Route tables are set up to manage traffic flow between the private and public subnets.

## Table of Contents

- [Project Overview](#project-overview)
- [Prerequisites](#prerequisites)
- [Setup Instructions](#setup-instructions)
- [Usage](#usage)
- [Troubleshooting](#troubleshooting)
- [License](#license)

## Prerequisites

Before you begin, ensure you have the following:

- AWS Account with necessary permissions.
- Terraform installed.
- Ansible installed.
- AWS CLI configured with appropriate credentials.
- Basic knowledge of Terraform and AWS.

## Setup Instructions

### 1. **Clone the Repository**

```bash
git clone https://github.com/iamamash/Terraform-Module-Project.git
```

### 2. **Terraform Configuration**

- **Navigate to the Terraform Directory**:
  ```bash
  cd Terraform-Module-Project
  ```

- **Initialize Terraform**:
  ```bash
  terraform init
  ```

- **Plan the Terraform Deployment**:
  ```bash
  terraform plan
  ```

- **Apply the Terraform Configuration**:
  ```bash
  terraform apply
  ```

### 3. **Ansible Configuration**

- **Navigate to the AWS EC2 Instance and run the Ansible Playbook**:
  ```bash
  sudo chmod 400 /home/ubuntu/id_rsa
  sudo chown ubuntu:ubuntu /home/ubuntu/inventory
  sudo ansible -i /home/ubuntu/inventory -m ping private
  sudo ansible-playbook -i /home/ubuntu/inventory /home/ubuntu/playbook.yaml
  sudo ansible -i /home/ubuntu/inventory -a "sudo apt-get update -y" private
  ```

### 4. **Verify the Deployment**

- **API Gateway**:
  - Find the Invoke URL in the AWS API Gateway console.

- **Access Nginx**:
  - Ensure the Nginx service is accessible via the API Gateway URL.

## Usage

To access your Nginx service through the API Gateway, use the following URL format:

```plaintext
https://<api-id>.execute-api.<region>.amazonaws.com/<stage>
```

Replace `<api-id>`, `<region>`, and `<stage>` with the details from your API Gateway setup.

## Troubleshooting

- **"Missing Authentication Token" Error**:
  - Verify the resource path and method configuration in API Gateway.
  - Ensure that the API Gateway is correctly deployed.

- **Nginx Not Accessible**:
  - Check the configuration of your ALB and ensure it correctly forwards requests to the Nginx instances.
  - Verify that the security groups and network ACLs allow traffic as intended.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
