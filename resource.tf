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
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCI8j/wMlxcCWfcGPJlDF1BwbJzaH5upaG9sSefWhKMeFtThzXBqM3Ia68Xzgd8DufIjiFWIYiqwQCoreEOIdeLpYeDsLGSEmRBgEaM3jKjEiCRcuJwQgPAQOQezliPFUTrpzAulpTfG63uY73Ibl34bZW3zd1xPf5tTABr3UENZu/1BvdvrJ4nR1g1xLXU75wsd+s/D7pXI0yxglzDZA6jJhK9u/AaRzSv8eo+lEMhmZcKHu7MQti8yBTb8PsH8eq1m2w+tnw1BW8bA9PgATJcPpOGbvoxhyNLtiDxlkYLPqNychIOWXOPQlSNMhmGiJk/wLRNidOuINPXk4+gVRydISCHTnVIB/z/5KKXN02ZyLE1vJWIAvvwE7ZigfuHC0JiLYaD/Z2A8GnJdnOIWuix5D44YPibeWxyziVUdPaJWm5cokrJvMN3t0XV45CpW1u5yDBjNxQCviCk2ILPBTRca0SclmJsliwYobqjiqbtxz1Pj31E57FNNKi1c2v8N48= ubuntu@ip-172-31-38-141"

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
