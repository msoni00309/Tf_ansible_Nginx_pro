terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key

}

##Network related configs like, vpc, subnet, internet gw, route an association of subnet and route.
resource "aws_vpc" "this" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true
  tags = merge(var.tags, { Name = "${var.project_name}-vpc" })
}

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.10.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"
  tags = merge(var.tags, { Name = "${var.project_name}-public-a" })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.project_name}-igw" })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(var.tags, { Name = "${var.project_name}-rt-public" })
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}
## Creation of a RHEL 9 webserver
resource "aws_instance" "web" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_a.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  key_name                    = var.ssh_key_name
  associate_public_ip_address = true

  tags = merge(var.tags, { Name = "${var.project_name}-ec2" })
}
## Creation of a Ubuntu  webserver
resource "aws_instance" "ubuntu_web" {
  ami                         = var.ubuntu_ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_a.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  key_name                    = var.ssh_key_name
  associate_public_ip_address = true

  tags = merge(var.tags, { Name = "${var.project_name}-ec2" })
}
## Adding security groups to the above webserer
resource "aws_security_group" "web_sg" {
  name        = "${var.project_name}-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = aws_vpc.this.id

## Inbound rules
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.http_cidr]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allow_ssh_cidr]
  }
## Outbound rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(var.tags, { Name = "${var.project_name}-sg" })
}
## Creation of inventory file for ansible with the help of template
resource "local_file" "inventory" {
  depends_on = [aws_instance.web, aws_instance.ubuntu_web]

  filename = "${path.module}/ansible/inventory.ini"
  content  = templatefile("${path.module}/inventory.tpl", {
            public_ip = aws_instance.web.public_ip
            ubuntu_public_ip = aws_instance.ubuntu_web.public_ip
            pem_path  = var.private_key_path
  })
}
## Wait and run ansible to install and configure Nginx
resource "null_resource" "run_ansible" {
        depends_on = [aws_instance.web, aws_instance.ubuntu_web, local_file.inventory]

        provisioner "local-exec" {
                command = "sleep 40 && ansible-playbook -i ${path.module}/inventory.ini ${path.module}/ansible/nginx-amazon-linux.yml"
  }
}
