output "name" {
  value = "value"
}

output "vpc_id" {
   value = "${aws_vpc.main.id}"
}

output "public_subnet_id" {
    value = "${aws_subnet.public_az_a.id}"
}
output "private_subnet_id" {
    value = "${aws_subnet.private_az_b.id}"
}

