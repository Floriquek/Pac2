output "vpc_id" {

  value       = aws_vpc.uvpc.id
  description = "vpc id"

}

output "subnet_id" {
  value	      = aws_subnet.sub.id
  description = "subnet id"
}

output "sec_gr_id" {
  value       = aws_security_group.allow_ports.id
  description  = "security group id" 
}
