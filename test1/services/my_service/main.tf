
provider "aws" {
  region = "${var.region}"
}

data "aws_subnet" "public_subnet" {
   id = "${var.public_subnet_id}"
}


resource "aws_security_group" "web_sg_01" {
  vpc_id = "${var.vpc_id}"
  name   = "${var.project}_web_sg_01"
  ingress {
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    protocol         = "tcp"
    to_port          = 80
    from_port        = 80
  }
  ingress {
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    protocol         = "tcp"
    to_port          = 22
    from_port        = 22
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name    = "${var.project}_web_sg_01"
    Project = "${var.project}"
  }
}

# ===================================================================================
# Security group which allows (from public subnet):
# * ICMP (echo) we want to be able to ping it
# * HTTP/S 
# * MuSQL
# * SSH
# ===================================================================================



resource "aws_security_group" "db_sg_01" {
  vpc_id = "${var.vpc_id}"
  name   = "${var.project}_db_sg_01"
  ingress {
    cidr_blocks      = ["${data.aws_subnet.public_subnet.cidr_block}"]
    protocol         = "tcp"
    to_port          = 22
    from_port        = 22
  }
  ingress {
    cidr_blocks      = ["${data.aws_subnet.public_subnet.cidr_block}"]
    protocol         = "tcp"
    to_port          = 80
    from_port        = 80
  }
  ingress {
    cidr_blocks      = ["${data.aws_subnet.public_subnet.cidr_block}"]
    protocol         = "tcp"
    to_port          = 443
    from_port        = 443
  }
  ingress {
    cidr_blocks      = ["${data.aws_subnet.public_subnet.cidr_block}"]
    protocol         = "tcp"
    to_port          = 3306
    from_port        = 3306
  }
  ingress {
    cidr_blocks      = ["${data.aws_subnet.public_subnet.cidr_block}"]
    protocol         = "icmp"
    to_port          = -1
    from_port        = -1
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name    = "${var.project}_db_sg_01"
    Project = "${var.project}"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "${var.project}_ec2_key"
  public_key = "${file("test1_ec2_key.pub")}"
}

// INSTANCES 

/*

resource "aws_instance" "web_server_01" {
  ami                         = "ami-0dacb0c129b49f529"
  instance_type               = "t2.micro"
  key_name                    = "${aws_key_pair.deployer.key_name}"
  vpc_security_group_ids      = ["${aws_security_group.web_sg_01.id}"]
  subnet_id                   = "${var.public_subnet_id}"
  associate_public_ip_address = true
  user_data                   = <<EOF
      #!/bin/bash
      yum update -y
      yum install httpd -y
      service httpd start
      chkconfig httpd on
      cd /var/www/html
      echo "<html><h1>Hello. Welcome To My Webpage</h1></html>"  >  index.html
   EOF
  tags = {
    Name    = "${var.project}_web_inst_01"
    Project = "${var.project}"
  }
}

resource "aws_instance" "db_server_01" {
  ami                         = "ami-0dacb0c129b49f529"
  instance_type               = "t2.micro"
  key_name                    = "${aws_key_pair.deployer.key_name}"
  vpc_security_group_ids      = ["${aws_security_group.db_sg_01.id}"]
  subnet_id                   = "${var.private_subnet_id}"
  associate_public_ip_address = false
  tags = {
    Name    = "${var.project}_db_inst_01"
    Project = "${var.project}"
  }
}

*/
