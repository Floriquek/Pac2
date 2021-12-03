resource "aws_internet_gateway" "ugateway" {

     vpc_id = aws_vpc.uvpc.id

 }

 resource "aws_route" "route" {

     route_table_id         = aws_vpc.uvpc.main_route_table_id
     destination_cidr_block = "0.0.0.0/0"
     gateway_id             = aws_internet_gateway.ugateway.id

 }

