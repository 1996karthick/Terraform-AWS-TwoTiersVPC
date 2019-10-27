output "VPC-id" {
  value = "${aws_vpc.Byte13_VPC1.id}"
}

output "FrontSN-id" {
  value = "${aws_subnet.Byte13_FrontSN1.id}"
}

output "BackSN-id" {
  value = "${aws_subnet.Byte13_BackSN1.id}"
}

output "VPC-IPv4-CIDR" {
  value = "${aws_vpc.Byte13_VPC1.cidr_block}"
}

output "FrontSN-IPv4" {
  value = "${aws_subnet.Byte13_FrontSN1.cidr_block}"
}

output "BackSN-IPv4" {
  value = "${aws_subnet.Byte13_BackSN1.cidr_block}"
}

output "VPC-IPv6-CIDR" {
  value = "${aws_vpc.Byte13_VPC1.ipv6_cidr_block}"
}

output "FrontSN-IPv6" {
  value = "${aws_subnet.Byte13_FrontSN1.ipv6_cidr_block}"
}

output "BackSN-IPv6" {
  value = "${aws_subnet.Byte13_BackSN1.ipv6_cidr_block}"
}
