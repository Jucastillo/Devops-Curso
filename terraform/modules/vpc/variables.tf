variable "vpc_cidr" { type = string }
variable "region" { type = string }
variable "project_name" { type = string }
variable "public_subnet_cidrs" { type = list(string) }
variable "private_subnet_cidrs" { type = list(string) }