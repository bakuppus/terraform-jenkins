variable "a_key" {}
variable "s_key" {}

variable "region" {
  default = "us-east-1"
}

variable "aws_amis"{ 
default = { 
us-east-1="ami-97785bed" 
} 
}

variable "aws_keys"{
default = {
us-east-1="devec2-keypair"
}
} 

variable "aws_key_path"{
default = "/root/tf-codes/docker/devec2-keypair.pem"
}





