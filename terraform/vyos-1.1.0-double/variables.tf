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

variable "key_name" {
    description = "Name of the keypair to use in EC2."
    default = "terraform"
}

variable "key_path" {
    descriptoin = "Path to your private key."
    default = "~/.ssh/id_rsa"
}

variable "key_username" {
    descriptoin = "SSH Username"
    default = "vyos"
}

variable "vyos_1_1_0_ami" {
    description = "VyOS 1.1.0 AMI"
    default =  "ami-5e77c229"
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

