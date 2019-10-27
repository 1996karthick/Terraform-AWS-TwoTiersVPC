variable "ObjNames-Prefix" {
  description = "Prefix appended to cloud objects names"
}

variable "Tags-Prefix" {
  description = "Prefix appended to cloud objects tags"
}

variable EC2-AmiOwners {
    description = "AWS image owner"
}

variable EC2-AmiName {
    description = "AWS image name"
}

variable EC2-VirtType {
    description = "AWS virtualization type"
}

variable EC2-InstanceType {
    description = "AWS server type"
}

variable EC2-SSHPubKey {
    description = "SSH Public key authorized in EC2 instances"
}

variable FrontSN-id {
    description = "Subnet ID for frontend servers"
}

variable BackSN-id {
    description = "Subnet ID for backend servers"
}

variable FrontSG-id {
    description = "Security group ID for frontend servers"
}

variable BackSG-id {
    description = "Security group ID for backend servers"
}

