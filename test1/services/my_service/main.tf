
provider "aws" {
   region = "${var.region}"
}

resource "aws_security_group" "web_sg" {
   vpc_id = "${var.vpc_id}"
   ingress {
      cidr_blocks = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      protocol = "tcp"
      to_port = 80
      from_port = 80
   }
   ingress {
      cidr_blocks = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      protocol = "tcp"
      to_port = 22
      from_port = 22
   }
   tags = {
      Name = "${var.project}_sg_01"
      Project = "${var.project}"
   }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDBTe1FJS/1BO4yBJV1PkWPPxbEDZMubJpMTwvC0tTcWRzdDdUK+VLicM4cbI20k9HH0qMkHnFE0zER2RoV4KawBxYmat6+gxJHXlghUY4yxFKwe478wvXR8oWKw/IRVfPclcCna/uCNatLhqFhwZGIEjRs1jk8ikfp0MS6vBf3WTFK2WFa6DZiGvP2mKGjb56qB8LUm7IYG+1cwFWa9X9s4wiqvy6RDVcmPEA8QMcjp3w4upx4VVQXBkv9BoGZSN5UAxKx3zI43PMhnuoldFYvOiN4TXNmH4Qct0A+N5cvMpEMzKvUYbFE4SoxZVGuKypJ7OCTOYe6iezrYW/7EOSlXLNNWxcPNyqhdtkSBt3A0KxhKDwsjhQeobQ2UpgdV0QtqGf+9o1145u3/miDEf5RFKZ+MDaG7Pzsi6UcpJv2dTnlj3TgPaFHx4sKeNzhs9CaoySr/UbHN+Bb7fNxbRwnzZqlWWwC7vTwr5IqxOxRFBtLh6WA3gqoZNj29zU+eRU= Darren@CIC00988"
}

// INSTANCES 

resource "aws_instance" "web_server_01" {
   ami = "ami-0dacb0c129b49f529"
   instance_type = "t2.micro"
   key_name = "${aws_key_pair.deployer.key_name}"
   vpc_security_group_ids = ["${aws_security_group.web_sg.id}"]
   subnet_id = "${var.public_subnet_id}"
   associate_public_ip_address = true
   tags = {
      Name = "${var.project}_in_web_01"
      Project = "${var.project}"
   }
}

resource "aws_instance" "db_server_01" {
   ami = "ami-0dacb0c129b49f529"
   instance_type = "t2.micro"
   subnet_id = "${var.private_subnet_id}"
   associate_public_ip_address = false
   tags = {
      Name = "${var.project}_in_db_01"
      Project = "${var.project}"
   }
}


