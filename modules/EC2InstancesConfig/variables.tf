variable EC2-FrontendSRV-IPv6 {
    description = "IPv6 address of frontend host"
    type = list
}

variable EC2-FrontendSRV-PrivIPv4 {
    description = "Private IPv4 of frontend host"
}

variable EC2-FrontendSRV-PrivFQDN {
    description = "Private FQDN of frontend host"
}

variable EC2-FrontendSRV-PubFQDN {
    description = "Public FQDN of frontend host"
}

variable EC2-BackendSRV-IPv6 {
    description = "IPv6 address of backend host"
    type = list
}

#variable EC2-BackendSRV-PrivIPv4 {
#    description = "Private IPv4 of backend host"
#}

variable EC2-BackendSRV-PrivFQDN {
    description = "Private FQDN of backend host"
}

variable EC2-BackendSRV-PubFQDN {
    description = "Public FQDN of backend host"
}

variable SSH-agent-ID {
    description = "SSH agent ID"
}

variable SSH-username {
    description = "EC2 instance Linux account"
}

variable "Ansible-NC-MariaDB-Enabled" {
  description = "Variable to define if Nextcloud and MariaDB should be installed (true or false)"
}

variable Ansible-PlayDir {
    description = "Directory of Ansible palybooks and roles"
}

variable Nextcloud-DataDir {
    description = "Directory where Nextcloud stores uploaded data files"
}

variable Nextcloud-FQDN {
    description = "FQDN of Nextcloud site"
}

variable Nextcloud-Version {
    description = "Nextcloud version to be installed"
}

variable Ansible-NCVaultPwd {
    description = "Password to unlock Ansible vault password of Nextcloud role"
}

variable Ansible-RedisVaultPwd {
    description = "Password to unlock Ansible vault password of Redis role"
}

variable Letsencrypt-email {
    description = "Mail address specified in Let's Encrypt certificates"
}
