terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.28.0"
    }
  }
  backend "remote" {
    organization = "slang"
    # we prefix envs on Terraform Cloud with slang-
    workspaces {
      name = "tfc-guide-example"
    }
  }
}

provider "aws" {
      region = var.region
      profile = var.profile
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "ubuntu" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  tags = {
    Name                 = var.instance_name
    "Linux Distribution" = "Ubuntu"
  }
}
