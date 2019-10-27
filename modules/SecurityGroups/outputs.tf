output "FrontSG-id" {
  value = "${aws_security_group.Byte13_FrontSN1-SG1.id}"
}

output "BackSG-id" {
  value = "${aws_security_group.Byte13_BackSN1-SG1.id}"
}
