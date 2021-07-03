variable "region" { default = "us-east-2" }
variable "instance_type" { default = "t2.micro" }
variable "key_name" { default = "ram.pem" }
variable "vpc_id" { default = "vpc-0e0e9b65" }
variable "subnet_id" { 
    type        = list(string)
  default     = []
  description = "A list of public subnet ids."
}

variable "cidr_block" {
  type        = string
  description = "Base CIDR block which is divided into subnet CIDR blocks (e.g. `10.0.0.0/16`)."
cidr_block = "172.16.10.0/24"
}
