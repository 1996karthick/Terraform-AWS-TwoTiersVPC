# Create VPC using ${var.VPC-IPv4-CIDR} range as well as an IPv6 range (/56 by default)
resource "aws_vpc" "Byte13_VPC1" {
  cidr_block                       = var.VPC-IPv4-CIDR
  enable_dns_support               = true 
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name = "${var.Tags-Prefix}_TF_VPC1"
  }
}

# Create and assign an Internet Gateway to our VPC
# Used for IPv4 and IPv6 trafics
resource "aws_internet_gateway" "Byte13_IPGW1" {
  vpc_id = aws_vpc.Byte13_VPC1.id

  tags = {
    Name = "${var.Tags-Prefix}_TF_IPGW1"
  }
}

# Create IPv6 egress, only, gateway to enable backend EC2 instances to initiate trafics 
resource "aws_egress_only_internet_gateway" "Byte13_IPv6EgressGW1" {
  vpc_id = aws_vpc.Byte13_VPC1.id
}

# Allocate an elastic IP address for the IPv4 NAT gateway
resource "aws_eip" "Byte13_NATEIP" {
  depends_on = [aws_internet_gateway.Byte13_IPGW1]
  vpc        = true

  tags = {
    Name = "${var.Tags-Prefix}_TF_NATEIP"
  }
}

# Create IPv4 NAT gateway to enable backend EC2 instances to initiate trafics to Internet
resource "aws_nat_gateway" "Byte13_NATGW1" {
  allocation_id = aws_eip.Byte13_NATEIP.id
  subnet_id     = aws_subnet.Byte13_FrontSN1.id

  tags = {
    Name = "${var.Tags-Prefix}_TF_NATGW1"
  }
}

# Setup IP routing for our VPC
# Create route table for backend subnet
resource "aws_route_table" "Byte13_BackendSNRouteTable" {
  vpc_id = aws_vpc.Byte13_VPC1.id

  tags = {
    Name = "${var.Tags-Prefix}_TF_BackendSNRouteTable"
  }
}

# Add IPv4 default route in backend subnet route table
resource "aws_route" "Byte13_BackendSNIPv4DefNatRoute" {
  #depends_on             = [aws_internet_gateway.Byte13_NATGW1, aws_route_table.Byte13_BackendSNRouteTable]
  route_table_id         = aws_route_table.Byte13_BackendSNRouteTable.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.Byte13_NATGW1.id
}

# Add IPv6 default route in backend subnet route table
resource "aws_route" "Byte13_BackendSNIPv6DefRoute" {
  #depends_on                  = [aws_egress_only_internet_gateway.IPv6EgressGW1, aws_route_table.Byte13_BackendSNRouteTable]
  route_table_id              = aws_route_table.Byte13_BackendSNRouteTable.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.Byte13_IPGW1.id
  # In case ingress trafic to backend system should not be allowed, set an egress, ony, gateway
  #egress_only_gateway_id      = aws_egress_only_internet_gateway.Byte13_IPv6EgressGW1.id
}

# Create route table for frontend subnet
resource "aws_route_table" "Byte13_FrontendSNRouteTable" {
  vpc_id = aws_vpc.Byte13_VPC1.id

  tags = {
    Name = "${var.Tags-Prefix}_TF_FrontendSNRouteTable"
  }
}

# Add IPv4 default route in frontend subnet route table
resource "aws_route" "Byte13_FrontendSNIPv4DefRoute" {
  #depends_on             = ["aws_internet_gateway.Byte13_IPGW1", "${aws_route_table.Byte13_FrontendSNRouteTable"]
  route_table_id         = aws_route_table.Byte13_FrontendSNRouteTable.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.Byte13_IPGW1.id
}

# Add IPv6 default route in frontend subnet route table
resource "aws_route" "Byte13_FrontendSNIPv6DefRoute" {
  #depends_on                  = [aws_egress_only_internet_gateway.IPGW1, aws_route_table.Byte13_FrontendSNRouteTable]
  route_table_id              = aws_route_table.Byte13_FrontendSNRouteTable.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.Byte13_IPGW1.id
}

# Create a subnet to host frontend systems (those accessible from Internet)
resource "aws_subnet" "Byte13_FrontSN1" {
  vpc_id                          = aws_vpc.Byte13_VPC1.id
  # cidr_block                    = "10.13.1.0/24"
  cidr_block                      = cidrsubnet(aws_vpc.Byte13_VPC1.cidr_block, 8, 1)
  map_public_ip_on_launch         = true
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.Byte13_VPC1.ipv6_cidr_block, 8, 1)
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "${var.Tags-Prefix}_TF_FrontSN1"
  }
}

# Create a subnet to host backend systems 
resource "aws_subnet" "Byte13_BackSN1" {
  vpc_id                          = aws_vpc.Byte13_VPC1.id
  # cidr_block                    = "10.13.2.0/24"
  cidr_block                      = cidrsubnet(aws_vpc.Byte13_VPC1.cidr_block, 8, 2)
  # We map public IP's, yet, in order to provision with Ansible over SSH
  # Could be set to false when the systems are provisioned
  map_public_ip_on_launch         = false
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.Byte13_VPC1.ipv6_cidr_block, 8, 2)
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "${var.Tags-Prefix}_TF_BackSN1"
  }
}

# Associate route tables to subnets
resource "aws_route_table_association" "Byte13_BackendSNRouteAssociation" {
  #depends_on     = [aws_subnet.Byte13_BackSN1}, aws_route_table.Byte13_BackendSNRouteTable]
  subnet_id      = aws_subnet.Byte13_BackSN1.id
  route_table_id = aws_route_table.Byte13_BackendSNRouteTable.id
}

resource "aws_route_table_association" "Byte13_FrontendSNRouteAssociation" {
  #depends_on     = [aws_subnet.Byte13_FrontSN1, aws_route_table.Byte13_FrontendSNRouteTable]
  subnet_id      = aws_subnet.Byte13_FrontSN1.id
  route_table_id = aws_route_table.Byte13_FrontendSNRouteTable.id
}

