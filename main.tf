provider "aws" {
  region = "${var.region}"
}

module "vpc" {
  source = "./vpc"
}
module "service" {
  source            = "./services/my_service"
  vpc_id            = "${module.vpc.vpc_id}"
  public_subnet_id  = "${module.vpc.public_subnet_id}"
  private_subnet_id = "${module.vpc.private_subnet_id}"
}

