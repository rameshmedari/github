provider "aws" {
    access_key = "AKIASI56IEMAIHP4D2U6"
    secret_key = "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"
    region = "us-east-2"
}

## Create VPC ##
resource "aws_vpc" "terraform-vpc" {
  cidr_block       = "172.16.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "terraform-vpc"
  }
}

output "aws_vpc_id" {
  value = "${aws_vpc.terraform-vpc.id}"
}

## Security Group##
resource "aws_security_group" "terraform_sg" {
  description = "Allow limited inbound external traffic"
  vpc_id      = "${aws_vpc.terraform-vpc.id}"
  name        = "terraform_sg"

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
  }

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8080
    to_port     = 8080
  }

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
  }

  egress {
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
  }

  tags = {
    Name = "terraform-sg"
  }
}

output "aws_security_gr_id" {
  value = "${aws_security_group.terraform_sg.id}"
}

## Create Subnets ##
resource "aws_subnet" "terraform-subnet_1" {
  vpc_id     = "${aws_vpc.terraform-vpc.id}"
  cidr_block = "172.16.10.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "terraform-subnet_1"
  }
}

output "aws_subnet_subnet_1" {
  value = "${aws_subnet.terraform-subnet_1.id}"
}

resource "aws_instance" "terraform_ec2" {
    ami = "ami-00399ec92321828f5"
    instance_type = "t2.micro"
    vpc_security_group_ids =  [ "${aws_security_group.terraform_sg.id}" ]
    subnet_id = "${aws_subnet.terraform-subnet_1.id}"
    key_name               = "ram"
    count         = 1
    associate_public_ip_address = true
    tags = {
      Name              = "terraform_ec2"
      Environment       = "development"
      Project           = "DEMO-TERRAFORM"
    }
}

output "instance_id_list"     { value = ["${aws_instance.terraform_ec2.*.id}"] }
