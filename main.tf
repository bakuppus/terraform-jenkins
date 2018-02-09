provider "aws" { 
access_key = "${var.a_key}" 
secret_key = "${var.s_key}" 
region = "${var.region}" 
}

resource "aws_security_group" "default"{ 
name="terraform-sg" 
description="Created by terraform" 
ingress{ 
from_port = 22 
to_port = 22 
protocol= "tcp" 
cidr_blocks = ["0.0.0.0/0"] 
}
ingress{ 
from_port = 80 
to_port = 80 
protocol = "tcp" 
cidr_blocks = ["0.0.0.0/0"] 
}

ingress{
from_port = 8080
to_port = 8080
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}

egress { 
from_port = "0" 
to_port = "0" 
protocol = "-1" 
#self = false
cidr_blocks = ["0.0.0.0/0"] 
}
}


resource "aws_instance" "example" { 
connection={ 
user="ec2-user" 
private_key = "${file(var.aws_key_path)}"
}
ami = "${lookup(var.aws_amis, var.region)}" 
instance_type = "t2.micro" 
iam_instance_profile = "ECR-Custom-Role"
tags { 
Name = "terraform-example" 
}
key_name = "${lookup(var.aws_keys, var.region)}"
security_groups = ["${aws_security_group.default.name}"]
provisioner "remote-exec" {
inline=[ 
"ping -c 10 8.8.8.8", 
"sudo yum  update -y", 
"sudo yum install docker -y", 
"sudo service docker restart",
"aws_login=$(aws ecr get-login --no-include-email --region us-east-1 | sed 's|https://||')",
"if echo $aws_login | grep -q -E '^docker login' ; then sudo $aws_login; fi",
"sudo docker pull 702401326258.dkr.ecr.us-east-1.amazonaws.com/jenkins-final1:latest",
"sudo docker run -dit -p 8080:8080 702401326258.dkr.ecr.us-east-1.amazonaws.com/jenkins-final1:latest"
] 
}
}

resource "aws_eip" "ip" { 
instance = "${aws_instance.example.id}" 
provisioner "local-exec" { 
command = "echo ${aws_eip.ip.public_ip} > ip_address.txt" 

}
}


