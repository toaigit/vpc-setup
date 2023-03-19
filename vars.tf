
variable stanford_cidr {
   type        = string
   description = "Stanford Network"
   default     = "131.64.0.0/14"
   }

variable world_cidr {
   type        = string
   description = "The World Wide Web"
   default     = "0.0.0.0/0"
   }

variable vpc_name {
   type        = string
   description = "My ProjectVPC"
   default     = "cia_vpc"
   }

variable "vpc_cidr_block" {
  type  = string
  description = "VPC CIDR values"
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
 type        = list(string)
 description = "Toai Public Subnet"
 default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}
 
variable "private_subnet_cidrs" {
 type        = list(string)
 description = "Toai Private Subnet"
 default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "environment" {
  type  = string
  description = "Dev Environment"
  default = "DEV"
}

variable "azs" {
  type = list(string)
  description = "Availability Zones"
  default = ["us-west-2a", "us-west-2b", "us-west-2c"]
  }
