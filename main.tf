
provider "aws" {
    region = "eu-central-1"
}

variable "ami_type" {
  type = string
  description = "Security group name"
  default = "ami-042e8287309f5df03"
}
variable "ssh_key_name" {
  type = string
  description = "Security group name"
  default = "devops-training"
}

resource "aws_instance" "docker server"{
    ami = var.ami_type
    instance_type="t2.micro"
    vpc_security_group_ids = [aws_security_group.allow_ssh_and_5000.id]
    key_name=var.ssh_key_name
    user_data = <<EOF
#!/bin/bash
apt update -y
EOF
}

resource "aws_security_group" "allow_ssh_and_5000" {
  name        = "allow_http_ssh"
  description = "Allow HTTP inbound traffic"
  #vpc_id      = aws_vpc.main.id

  ingress {
    description = "5000 from any"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from any"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["46.53.128.0/17"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh_and_5000"
  }
}
