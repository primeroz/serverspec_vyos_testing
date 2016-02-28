variable "access_key" {
    description = "AWS access key."
}

variable "secret_key" {
    description = "AWS secret key."
}

variable "region" {
    description = "The AWS region to create things in."
    default = "eu-west-1"
}

variable "ssh_keyname" {
    description = "Name of the keypair to use in EC2."
    default = "terraform"
}

variable "ssh_keypath" {
    descriptoin = "Path to your private key."
    default = "~/.ssh/id_rsa"
}

variable "ssh_username" {
    descriptoin = "SSH Username"
    default = "vyos"
}

variable "vyos_ami" {
    description = "VyOS AMI"
}

variable "vyos_version" {
    description = "VyOS Version"
}

variable "subnet_id" {
    description = "A subnet ID where to start the instance. Probably the default VPC" 
}

variable "project" {
    description = "Project name"
}

variable "env" {
    description = "Project Environment"
}

variable "instance_type" {
    description = "Instance Type"
    default = "t2.micro"
}

variable "internal_ip_vyos01_tun1_range" {
    description = "Internal Ip range Tun1 Vyos01"
}

variable "internal_ip_vyos02_tun1_range" {
    description = "Internal Ip range Tun1 Vyos02"
}

variable "internal_ip_vyos01_tun1_ip" {
    description = "Internal Ip Tun1 Vyos01"
}

variable "internal_ip_vyos02_tun1_ip" {
    description = "Internal Ip Tun1 Vyos02"
}

variable "internal_ip_vyos01_tun1_rtr_id" {
    description = "Internal Ip Tun1 rtr id Vyos01"
}

variable "internal_ip_vyos02_tun1_rtr_id" {
    description = "Internal Ip Tun1 rtr id Vyos02"
}

variable "ospf_area_0_tun1_range" {
    description = "OSPF Area 0 tun2 Range"
}
