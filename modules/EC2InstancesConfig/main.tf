####################################################################
# The following blocks prepare Ansible inventory files with
# respective EC2 instances IP address or FQDN
#
provider "local" {
    version = "~> 1.3"
}

provider "template" {
    version = "~> 2.1"
}

#data  "template_file" "Frontend-servers_template" {
#    template = file("./templates/Frontend-servers_inventory.tpl")
#    vars {
#        # If IPv6 is used for configuration over SSH
#        Frontend-server = join("\n", var.EC2-FrontendSRV-IPv6)
#        # If IPv4 is used for configuration over SSH
#        #Frontend-server = var.EC2-FrontendSRV-PubFQDN
#    }
#}

resource "local_file" "Frontend-servers_inventory-file" {
#    content  = data.template_file.Frontend-servers_template.rendered
# If IPv4 is used for configuration over SSH
#    content  = templatefile("./templates/Frontend-servers_inventory.tpl", {Frontend-server = var.EC2-FrontendSRV-PubFQDN[0]}) 
# If IPv6 is used for configuration over SSH
    content  = templatefile("./templates/Frontend-servers_inventory.tpl", {Frontend-server = var.EC2-FrontendSRV-IPv6[0]}) 
    filename = "${var.Ansible-PlayDir}/Frontend-servers_inventory"
    file_permission = 640
}

# The following blocks prepare Ansible inventory file for backend server 
#data  "template_file" "Backend-servers_template" {
#    template = file("./templates/Backend-servers_inventory.tpl")
#    vars {
#        # If IPv6 is used for configuration over SSH
#        Backend-server = join("\n", var.EC2-BackendSRV-IPv6)
#        # If IPv4 is used for configuration over SSH
#        #Backend-server = var.EC2-BackendSRV-PubFQD
#    }
#}

resource "local_file" "Backend-servers_inventory-file" {
#    content  = data.template_file.Backend-servers_template.rendered
# If IPv4 is used for configuration over SSH
#    content  = templatefile("./templates/Backend-servers_inventory.tpl", {Backend-server = var.EC2-BackendSRV-PubFQDN[0]}) 
# If IPv6 is used for configuration over SSH
    content  = templatefile("./templates/Backend-servers_inventory.tpl", {Backend-server = var.EC2-BackendSRV-IPv6[0]}) 
    filename = "${var.Ansible-PlayDir}/Backend-servers_inventory"
    file_permission = 640
}
#
# End of preparation of Ansible inventory files
####################################################################

provider "null" {
    version = "~> 2.1"
}

# Perfrom SysAdmin operations on backend server
resource "null_resource" "Byte13_NullRES1" {

    # Check if the resource is to be created
    count = var.Ansible-MariaDB-Enabled == true ? 1 : 0
    
    provisioner "remote-exec" {
        connection {
            type           = "ssh"
            # If IPv6 is used for configuration over SSH
            host           = var.EC2-BackendSRV-IPv6[0]
            # If IPv4 is used for configuration over SSH
            #host           = var.EC2-BackendSRV-PubFQDN
            agent          = "true"
            agent_identity = var.SSH-agent-ID
            user           = var.SSH-username
        }

        # Ensure apt is clean and install some facilities
        inline = [
          "sudo rm -rf /var/lib/apt/lists/*",
          "sudo apt-get clean",
          "sudo apt update",
          #"sudo apt -y dist-upgrade",
          "sudo apt -y install aptitude",
          "sudo apt -y install nmap",
          "sudo apt -y install hping3",
          "sudo apt -y install htop"
        ]
    }

    # This is where we install MariaDB on backend server using ansible-playbook
    provisioner "local-exec" {
        # Without checking SSH remote host key (NOT a good security practice)
        # To be safer, change "StrictHostKeyChecking=no" to "StrictHostKeyChecking=yes" on next line
        command = "cd ${var.Ansible-PlayDir} && ansible-playbook -u ${var.SSH-username} --ssh-common-args='-o StrictHostKeyChecking=no' -i '${var.Ansible-PlayDir}/Backend-servers_inventory' -l AWS_MariaDB --extra-vars 'nc_serverPrivIP=${var.EC2-FrontendSRV-PrivIPv4} nc_serverPrivFQDN=${var.EC2-FrontendSRV-PrivFQDN} nc_dbserver=${var.EC2-BackendSRV-PrivFQDN} nc_trusteddomain=${var.Nextcloud-FQDN} nc_version=${var.Nextcloud-Version}' --vault-id nc@${var.Ansible-NCVaultPwd} Linux_Install-NextCloud_with-roles.yml"
    }

    # Remove Ansible inventory for backend servers 
    provisioner "local-exec" {
        command = "if [ -f ${var.Ansible-PlayDir}/Backend-servers_inventory ] ; then shred -u -z ${var.Ansible-PlayDir}/Backend-servers_inventory ; fi"
    }
}

# Perfrom SysAdmin operations on frontend server 
resource "null_resource" "Byte13_NullRES2" {
    
  # Wait for MariaDB backend to be available
    depends_on             = [null_resource.Byte13_NullRES1]
    
    # Check if the resource is to be created
    count = var.Ansible-NC-Enabled == true ? 1 : 0
    
    provisioner "remote-exec" {
        connection {
            type           = "ssh"
            # If IPv6 is used for configuration over SSH
            host           = var.EC2-FrontendSRV-IPv6[0]
            # If IPv4 is used for configuration over SSH
            #host           = var.EC2-FrontendSRV-PubFQDN
            agent          = "true"
            agent_identity = var.SSH-agent-ID
            user           = var.SSH-username
        }

        # Ensure apt is clean and install some facilities
        inline = [
          "sudo rm -rf /var/lib/apt/lists/*",
          "sudo apt-get clean",
          "sudo apt update",
          #"sudo apt -y dist-upgrade",
          "sudo apt -y install aptitude",
          "sudo apt -y install nmap",
          "sudo apt -y install hping3",
          "sudo apt -y install htop"
        ]
    }

    # This is where we install Nextcloud on frontend server using ansible-playbook
    provisioner "local-exec" {
        # Without checking SSH remote host key (NOT a good security practice)
        # To be safer, change "StrictHostKeyChecking=no" to "StrictHostKeyChecking=yes" on next line
        command = "cd ${var.Ansible-PlayDir} && ansible-playbook -u ${var.SSH-username} --ssh-common-args='-o StrictHostKeyChecking=no' -i '${var.Ansible-PlayDir}/Frontend-servers_inventory' -l AWS_Nextcloud --extra-vars 'nc_version=${var.Nextcloud-Version} nc_dbserver=${var.EC2-BackendSRV-PrivFQDN} nc_trusteddomain=${var.Nextcloud-FQDN} nc_datadir=${var.Nextcloud-DataDir} le_email=${var.Letsencrypt-email}' --vault-id redis@${var.Ansible-RedisVaultPwd}  --vault-id nc@${var.Ansible-NCVaultPwd} Linux_Install-NextCloud_with-roles.yml"
    }

    # Remove Ansible inventory for Frontend servers 
    provisioner "local-exec" {
        command = "if [ -f ${var.Ansible-PlayDir}/Frontend-servers_inventory ] ; then shred -u -z ${var.Ansible-PlayDir}/Frontend-servers_inventory ; fi"
    }
}
