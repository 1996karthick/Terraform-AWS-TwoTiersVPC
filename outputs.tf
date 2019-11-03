output "VPC-IPv4-CIDR-block" {
  value = module.TwoTiersVPC.VPC-IPv4-CIDR
}

output "VPC-IPv4-front-subnet" {
  value = module.TwoTiersVPC.FrontSN-IPv4
}

output "VPC-IPv4-back-subnet" {
  value = module.TwoTiersVPC.BackSN-IPv4
}

output "VPC-IPv6-CIDR-block" {
  value = module.TwoTiersVPC.VPC-IPv6-CIDR
}

output "VPC-IPv6-front-subnet" {
  value = module.TwoTiersVPC.FrontSN-IPv6
}

output "VPC-IPv6-back-subnet" {
  value = module.TwoTiersVPC.BackSN-IPv6
}

output "EC2-Backend-server-private-IPv4-addresses" {
  value = module.EC2Instances.EC2-BackendSRV-PrivIPv4
}

output "EC2-Backtend-server-public-IPv4-address" {
  value = module.EC2Instances.EC2-BackendSRV-PubIPv4
}

output "EC2-Backend-server-IPv6-addresses" {
  value = module.EC2Instances.EC2-BackendSRV-IPv6
}

output "EC2-Backend-server-public-FQDN" {
  value = module.EC2Instances.EC2-BackendSRV-PubFQDN
}

output "EC2-Backend-server-private-FQDN" {
  value = module.EC2Instances.EC2-BackendSRV-PrivFQDN
}

output "EC2-Frontend-server-private-IPv4-address" {
  value = module.EC2Instances.EC2-FrontendSRV-PrivIPv4
}

output "EC2-Frontend-server-public-IPv4-address" {
  value = module.EC2Instances.EC2-FrontendSRV-PubIPv4
}

output "EC2-Frontend-server-IPv6-addresses" {
  value = module.EC2Instances.EC2-FrontendSRV-IPv6
}

output "EC2-Frontend-server-public-FQDN" {
  value = module.EC2Instances.EC2-FrontendSRV-PubFQDN
}

output "EC2-Frontend-server-private-FQDN" {
  value = module.EC2Instances.EC2-FrontendSRV-PrivFQDN
}

output "Nextcloud-FQDN" {
  value = var.Nextcloud-FQDN
}
