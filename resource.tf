data "aws_vpc" "vpc_id" {
  default = true
}

data "aws_subnet" "subnet1" {
  vpc_id            = data.aws_vpc.vpc_id.id
  availability_zone = "us-east-1a"
}
data "aws_security_group" "test" {
  vpc_id = data.aws_vpc.vpc_id.id
  filter {
    name   = "tag-key"
    values = ["Name"]
  }

  filter {
    name   = "tag-value"
    values = ["allports"]
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "love"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDpbIl5BfMU6dsBvqnaDeK0RAXnge2G8s0vxMH2lAayJO/LR2eB/sKm/0RM+8Rt0NQ3aH5gKVjYFpVDqTx895nxCg32+jp0MXVH5Ptc9D5uT/RxIU1dtiGhOYrVXPzxQF5RksK1XigCSuxh1eIBgLLF6chBpYbCL+dLHKnEeWBM/zh5wIvAENGHgpKFKbecf2o8CHyEHil/CtkceL2PvtoMpQtWLavUkXSBIoQ8/HSHuBuZco7s9uB4PFRXMKlMvyArqc/S1WEpKi9O+Y1PngBDEzACpCizha/VZryAj0Yh7RtZT7NBw91KZ+UTRjBqyyIvJnoTX7an0yeUn7bgST16bq3tVAwg/Nsvk8hVrpHOQ9fGplRLyxG5W4EFQyF00ZwaxFwUViVuzKpi99U457dG+FP/2lWv+x4khIS3rPSDQkJH2ZKGZkW9wmgVWF0L2HlYha4Y7pzzKvR+GdKUumq/e9oCRmwc+qfQJiUwqnwPtCQB618CJAIGv+pKK22kvB8= ubuntu@ip-172-31-33-65"

}

resource "aws_instance" "kala" {
  ami                    = "ami-007855ac798b5175e"
  instance_type          = "t2.medium"
  vpc_security_group_ids = [data.aws_security_group.test.id]
  subnet_id              = data.aws_subnet.subnet1.id
  key_name               = "love"
  tags = {
    "Name" = "kala"
  }
}


resource "null_resource" "laptop" {
  triggers = { laptop_number = 1.9 }


  connection {
    host        = aws_instance.kala.public_ip
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("/home/ubuntu/.ssh/id_rsa")

  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install software-properties-common",
      "sudo add-apt-repository --yes --update ppa:ansible/ansible",
      "sudo apt install ansible -y",
      "ansible --version"
    ]
  }

}