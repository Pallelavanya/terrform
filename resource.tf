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
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC9+mDlCNa8B11HHmEeOLVIl9uQ6zj4Fj2n89E+PoEbl6nRd9R7vuX0YvYGqFisK0xrGOTNR8SL6ELpO6U/MmtYEYbjcJ6dDBKqAXxRX4LQxID7fav+wa2SsqcGFqv/rdSATN8/5eSZzk9BgM5PTBf6RvVzWcoX9z7hh1M/KcAS8Fk31Pkh3wcP6/APUlgFy5rRuJq84/bRg6w/nAJn+k12SCKQbBqkNnAb+a1DPiOV8+U8dGIc7s9Ulc14nmcVzkL/K0/MIdXnKrjxYbP4bVFyAYbpuEa8gL0CXTR6Gvag/wNdCPrd76Tk6Om7WN0ODZxtCta5TuZ2RFWq8u8UT6gdEgRN8MOYuDj7HGVxSN9ih5X4i4qzLiOWMKy1aKQhEaLWDBkUAJzh1asBON/cehUQmR86EF89al4LBgu84pamZZshIRj1yA+ltTq2j4446zcg73wytN/H8Xe2c/D9wUaal2bUQTcTx/09Ky161XYVLJNkjwkKm1dk/4nMaPV/UiM= 91630@Lavanya"

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
    private_key = file("~/.ssh/id_rsa")

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