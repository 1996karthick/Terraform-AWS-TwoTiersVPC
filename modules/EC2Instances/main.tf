data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.EC2-AmiName]
  }

  filter {
    name   = "virtualization-type"
    values = [var.EC2-VirtType]
  }

  owners = [var.EC2-AmiOwners] # Canonical
}

resource "aws_key_pair" "Byte13_SSHPubKey" {
  key_name   = "${var.ObjNames-Prefix}_SSHPubKey"
  public_key = file(var.EC2-SSHPubKey)
  #public_key = var.EC2-SSHPubKey
}

resource "aws_instance" "Byte13_BackendSRV1" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.EC2-InstanceType
  key_name                    = "${var.ObjNames-Prefix}_SSHPubKey"
  subnet_id                   = var.BackSN-id 
  vpc_security_group_ids      = [var.BackSG-id]
  # IPV4 public IPv4 address not required if IPv6 with egress, only, route is set
  associate_public_ip_address = false

  tags = {
    Name = "${var.Tags-Prefix}_TF_BackendSRV1"
  }
}

resource "aws_instance" "Byte13_FrontendSRV1" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.EC2-InstanceType
  key_name                    = "${var.ObjNames-Prefix}_SSHPubKey"
  subnet_id                   = var.FrontSN-id 
  vpc_security_group_ids      = [var.FrontSG-id]
  # Interesting description of Eslastic IP's and Public IP's :
  # https://kerneltalks.com/cloud-services/difference-between-elastic-ip-and-public-ip/
  # Basically, Public IP changes each time the instance is restarted (dynamic IP)
  #            Elastic IP is static and keeps assigned (and charged) while the instance is down.
  associate_public_ip_address = true

  tags = {
    Name = "${var.Tags-Prefix}_TF_FrontendSRV1"
  }
}

# Interesting description of Eslastic IP's and Public IP's :
# https://kerneltalks.com/cloud-services/difference-between-elastic-ip-and-public-ip/
# Basically, Public IP changes each time the instance is restarted (dynamic IP)
#            Elastic IP is static and keeps assigned (and charged) while the instance is down.
#resource "aws_eip" "Byte13_FrontIPv4EIP" {
#  vpc                       = true
#  instance                  = aws_instance.Byte13_TF_FrontendSRV1.id
#
#  tags = {
#    Name = "${var.Tags-Prefix}_TF_FrontIPv4EIP"
#  }
#}

