variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overriden"
  default     = "10.0.0.0/16"
}

variable "region" {
  description = "The region for this VPC"
  default = "us-east-2" // OHIO
}

variable "project" {
  default="test1"
}
