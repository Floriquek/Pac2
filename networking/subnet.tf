resource "aws_subnet" "sub" {

  vpc_id =  aws_vpc.uvpc.id

  cidr_block = "10.0.1.0/24"
  
  map_public_ip_on_launch = "true"

  tags = {
    Name = "subnet-packer"
  }

}

