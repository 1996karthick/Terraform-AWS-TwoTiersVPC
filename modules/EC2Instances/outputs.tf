output "EC2-FrontendSRV-PrivIPv4" {
  value = "${aws_instance.Byte13_FrontendSRV1.private_ip}"
}

output "EC2-FrontendSRV-PubIPv4" {
  value = "${aws_instance.Byte13_FrontendSRV1.public_ip}"
}

output "EC2-FrontendSRV-IPv6" {
  value = "${aws_instance.Byte13_FrontendSRV1.ipv6_addresses}"
}

output "EC2-FrontendSRV-PubFQDN" {
  value = "${aws_instance.Byte13_FrontendSRV1.public_dns}"
}

output "EC2-FrontendSRV-PrivFQDN" {
  value = "${aws_instance.Byte13_FrontendSRV1.private_dns}"
}

output "EC2-BackendSRV-PrivIPv4" {
  value = "${aws_instance.Byte13_BackendSRV1.private_ip}"
}

output "EC2-BackendSRV-PubIPv4" {
  value = "${aws_instance.Byte13_BackendSRV1.public_ip}"
}

output "EC2-BackendSRV-IPv6" {
  value = "${aws_instance.Byte13_BackendSRV1.ipv6_addresses}"
}

output "EC2-BackendSRV-PubFQDN" {
  value = "${aws_instance.Byte13_BackendSRV1.public_dns}"
}

output "EC2-BackendSRV-PrivFQDN" {
  value = "${aws_instance.Byte13_BackendSRV1.private_dns}"
}
