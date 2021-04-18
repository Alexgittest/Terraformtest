
provider "aws" {
    region = "eu-central-1"
}

variable "ssh_key_name" {
  type = string
  description = "Security group name"
  default = "devops-training"
}

variable "my_ip" {
  type = list(string)
  description = "my ip addresses"
  default = ["46.53.128.0/17","18.197.151.117"]
}

data "aws_ami" "my_ubuntu" {
    most_recent=true
    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
    filter {
    name = "virtualization-type"
    values = ["hvm"]
    }
    owners = ["099720109477"]
}

resource "aws_instance" "docker_server"{
    ami = data.aws_ami.my_ubuntu.id
    instance_type="t2.micro"
    vpc_security_group_ids = [aws_security_group.allow_ssh_and_5000.id]
    key_name=var.ssh_key_name
    tags = {
        Name = "docker_server"
  }
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
    cidr_blocks = var.my_ip
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

output "ec2_pub_ip" {
    value = aws_instance.docker_server.public_ip
}
