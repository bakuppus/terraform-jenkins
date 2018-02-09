output "ip" { 
value = "${aws_eip.ip.public_ip}" 
}


output "address"{ 
value="${aws_instance.example.public_dns}" 
}
