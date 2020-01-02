# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE ALL THE RESOURCES TO CREATE OUR VPC
# This template creates all the necssary resources for the "kango" VPC.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# This module has been updated with 0.12 syntax, which means it is no longer compatible with any versions below 0.12.
# ----------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = "${var.region}"
}

resource "aws_vpc" "main" {
   cidr_block = "${var.vpc_cidr}"
   assign_generated_ipv6_cidr_block = true
   tags = {
      Name = "${var.project}_vpc"
      Project = "${var.project}"
   }
}

# ----------------------------------------------------------------------------------------------------------------------
# PUBLIC SUBNET FOR THE FRONT END 
# Template to create the subnet for the front-end applicatiion in region "a"
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_subnet" "public_az_a" {
   vpc_id     = "${aws_vpc.main.id}"
   cidr_block = "${cidrsubnet(aws_vpc.main.cidr_block, 8, 1)}"
   availability_zone = "${var.region}a"
   map_public_ip_on_launch = true
   tags = {
      Name = "${var.project}_sn_${element(split("/", cidrsubnet(aws_vpc.main.cidr_block, 8, 1)), 0)}_${var.region}a"
      Project = "${var.project}"
   }
}

# ----------------------------------------------------------------------------------------------------------------------
# PRIVATE SUBNET FOR THE BACK END DB
# Template to create the subnet for the back-end database "b"
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_subnet" "private_az_b" {
   vpc_id     = "${aws_vpc.main.id}"
   cidr_block = "${cidrsubnet(aws_vpc.main.cidr_block, 8, 2)}"
   availability_zone = "${var.region}b"
   map_public_ip_on_launch = true
   tags = {
      Name = "${var.project}_sn_${element(split("/", cidrsubnet(aws_vpc.main.cidr_block, 8, 2)), 0)}_${var.region}b"
      Project = "${var.project}"
   }
}

# ----------------------------------------------------------------------------------------------------------------------
# THE GATEWAY FOR OUR VPC
# Template to create the internet gateway for the VPC
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_internet_gateway" "main" {
   vpc_id = "${aws_vpc.main.id}"
   tags = {
      Name = "${var.project}_gw"
      Project = "${var.project}"
   }
}

# ----------------------------------------------------------------------------------------------------------------------
# THE ROUTING TABLE FOR OUR VPC
# Template to create the internet gateway for the VPC
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_route_table" "main" {
   vpc_id = "${aws_vpc.main.id}"
   route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.main.id}"
   }
   route {
      ipv6_cidr_block = "::/0"
      gateway_id = "${aws_internet_gateway.main.id}"
   }
   tags = {
      Name = "${var.project}_rt"
      Project = "${var.project}"
   }
}

resource "aws_route_table_association" "public" {
   subnet_id      = "${aws_subnet.public_az_a.id}"
   route_table_id = "${aws_route_table.main.id}"
}



