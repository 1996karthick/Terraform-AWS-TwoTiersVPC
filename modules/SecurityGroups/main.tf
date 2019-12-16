# Create Security Group for frontend subnet
# Create security groups to allow :
# - All EC2 instances to get to Internet for updates and other needs
# - All Internet to access 80/TCP and 443/TCP on EC2 instances connected to frontend subnets
# - Management systems, only, to connect over SSH to all AWS EC2 instances

# Configure the http Provider
provider "http" {
  version    = "~> 1.1"
}
 
# Get management current public IPv4 address
data "http" "CurrentExternalIPv4" {
  url ="https://v4.ident.me"
}
 
# Get management current public IPv6 address
data "http" "CurrentExternalIPv6" {
  url ="https://v6.ident.me"
}

# Security group for frontend systems
resource "aws_security_group" "Byte13_FrontSN1-SG1" {
  name        = "${var.ObjNames-Prefix}_FrontSN1-SG1"
  description = "Security group to get to/from frontend subnet"
  vpc_id      = var.VPC-id

  # SSH access from management system
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["${data.http.CurrentExternalIPv4.body}/32"]
    ipv6_cidr_blocks = ["${data.http.CurrentExternalIPv6.body}/128"]
  }

  # HTTP access from Internet
  ingress {
    from_port   = 80 
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access from Internet
  ingress {
    from_port   = 443 
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the VPC
  #ingress {
  #  from_port   = 80
  #  to_port     = 80
  #  protocol    = "tcp"
  #  cidr_blocks = ["10.0.0.0/16"]
  #}

  # Outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.Tags-Prefix}_TF_FrontSN1-SG1"
  }
}

# Create Security Group for backend subnet
# Security group for backend systems
resource "aws_security_group" "Byte13_BackSN1-SG1" {
  name        = "${var.ObjNames-Prefix}_BackSN1-SG1"
  description = "Security group to get to/from backtend subnet"
  vpc_id      = var.VPC-id

  # SSH access from management system, only
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["${data.http.CurrentExternalIPv4.body}/32"]
    ipv6_cidr_blocks = ["${data.http.CurrentExternalIPv6.body}/128"]
  }

  # MySQL access from frontend subnet 
  ingress {
    from_port        = 3306 
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = [var.FrontSN-IPv4]
    ipv6_cidr_blocks = [var.FrontSN-IPv6]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.Tags-Prefix}_TF_BackSN1-SG1"
  }
}
