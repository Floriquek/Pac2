module "networking" { 
	source="../networking"
}

variable "ami_host" {
}

resource "aws_instance" "example" {

  instance_type = "t2.micro"

  ami       = var.ami_host

  subnet_id = module.networking.subnet_id

  vpc_security_group_ids = [module.networking.sec_gr_id]


  tags = {
    Name = "MyPackerInstance"
  }

}
