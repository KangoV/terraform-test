variable "project" {
  default="test1"
}

variable "region" {
  description = "The region for this service"
  default = "us-east-2" // OHIO
}

variable "vpc_id" {}
variable "public_subnet_id" {}
variable "private_subnet_id" {}

