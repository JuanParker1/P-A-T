variable "aws_region" {
    default = "ap-south-1"
}

variable "ec2-ami" {
    default = "ami-06a0b4e3b7eb7a300"
}

variable "instance_type" {
    default = "t2.micro"
}

variable  "ec2_keypair" {
    default = "jenkins-pipelines"
}

variable "ec2_count" {
    type = number
    default = "2"
}

variable "vpc_security_group" {
    default = ["sg-07243c3762e88e437"]
}

variable "environment" {
    default ="dev"
}

variable "product" {
    default = "server"
}

variable "subnets" {
    type = list
    default = ["subnet-0bee8832e401ccc6b","subnet-01d1fa65065bf0797"]
}

variable "vpc_id" {
    default = "vpc-05fdf739745f2db7f"
} 

variable "instance1_id" {
    default = "i-0f6f9f7fc34515846"
}

variable "instance2_id" {
    default = "i-0be843220def52863"
}

variable "server_port" {
    default = "80"
}

variable "site-name" {
  type    = string
  default = "pat"
}