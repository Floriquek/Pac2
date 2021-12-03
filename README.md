# Pac2

Obviously, Packer Automation nr 2! 

Here we will be using less hardcoded parts in the code.


Structure of the repository:


```
root@kek:/home/wrenchie/Pac2# tree .
.
├── README.md
├── instance
│   ├── instance.tf
│   ├── provider.tf
│   └── variables.tf
├── networking
│   ├── internet_gateway.tf
│   ├── output.tf
│   ├── provider.tf
│   ├── security_group.tf
│   ├── subnet.tf
│   ├── variables.tf
│   └── vpc.tf
└── packer_terraform
    ├── aws-ubuntu.pkr.hcl
    ├── mwehehe.pkrvar.hcl
    ├── packer.tf
    ├── provider.tf
    └── variables.pkr.hcl

3 directories, 16 files
```


[ 1 ] Proceed with the creation of vpc, public subnet, internet gateway, etc...


```
root@kek:/home/wrenchie/Pac2# cd networking
root@kek:/home/wrenchie/Pac2/networking# terraform init
[ ... snip ... ]
root@kek:/home/wrenchie/Pac2/networking# terraform plan
[ ... snip ... ]
root@kek:/home/wrenchie/Pac2/networking# terraform apply
[ ... snip ... ]
Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

Outputs:

sec_gr_id = "sg-059514459484a5e27"
subnet_id = "subnet-0844af68b003fdae3"
vpc_id = "vpc-0d825275c3f581ebb"

```

Make sure you grab the output for subnet_id and vpc_id, and change the variables name - you will need to add these values to mwehehe.pkrvar.hcl file for packer:

```
root@kek:/home/wrenchie/Pac2/networking# terraform output | grep -w 'subnet*\|vpc*' | sed 's/_id/1/g' > ../packer_terraform/mwehehe.pkrvar.hcl
root@kek:/home/wrenchie/Pac2/networking# more ../packer_terraform/mwehehe.pkrvar.hcl
subnet1 = "subnet-0844af68b003fdae3"
vpc1 = "vpc-0d825275c3f581ebb"

``` 

[ 2 ] Since networking side is setup, go to packer_terraform folder, and build the Packer AMI (yeah, just like in Pac1, except this time, 
we provide as variables the subnet & vpc we just created at step 1):

```
root@kek:/home/wrenchie/Pac2/networking# cd ../packer_terraform/
root@kek:/home/wrenchie/Pac2/packer_terraform#  terraform init
[ ... snip ... ]
root@kek:/home/wrenchie/Pac2/packer_terraform#  terraform plan
[ ... snip ... ]
root@kek:/home/wrenchie/Pac2/packer_terraform#  terraform apply
[ ... snip ... ]
```

Check if amihost.tfvars has been created:

```
root@kek:/home/wrenchie/Pac2/packer_terraform# more amihost.tfvars
ami_host = "ami-0e6346c79159d3ddc"

```


Aight!, our Packer AMI seems to be ready to use.

```
root@kek:/home/wrenchie/Pac2/packer_terraform#aws ec2 describe-images --region us-east-2  --owners=self |\
>  jq -r '.Images[] | "\(.ImageId)\t\(.Name)\t\(.State)"'

```

[ 3 ] Deploy an instance to test it

Since I did a folder "instance" that calls the "networking" module for creating the EC2 instance, 
it might be a nice idea to destroy the resources for networking (unless you want two of each * winks * winks * ). This way, we can test this stuff better. 

```
root@kek:/home/wrenchie/Pac2/networking# terraform destroy
[ ... snip ... ]
```
Of course, just like in Pac1, we need to build our environment with the help of amihost.tfvars:

```
root@kek:/home/wrenchie/Pac2/instance# terraform init
[... snip ... ]
```

```
root@kek:/home/wrenchie/Pac2/instance# terraform plan -var-file=../packer_terraform/amihost.tfvars
[... snip ... ]

  # aws_instance.example will be created
  + resource "aws_instance" "example" {
      + ami                                  = "ami-0e6346c79159d3ddc"
      + arn                                  = (known after apply)

```

and build...
```
root@kek:/home/wrenchie/Pac2/instance# terraform apply -var-file=../packer_terraform/amihost.tfvars
[... snip ... ]

```

...once the instance is created, check if you can connect to public IP with your pem key (yeah, you should have a pem key created, just like in Pac1)

```
 root@kek:/home/wrenchie/Pac2/instance#  terraform output | awk {'print $3'} | sed 's/"//g'
 3.133.139.186
```

```
root@kek:/home/wrenchie/Pac2/instance# ssh -i ~/.aws/pems/key-pair-example.pem ubuntu@3.133.139.186 'uname -a'
[ ...snip ... ]
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
[ ...snip ... ]
Linux ip-10-0-1-85 4.4.0-1128-aws #142-Ubuntu SMP Fri Apr 16 12:42:33 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
root@kek:/home/wrenchie/Pac2/instance#
```


<i>Fini!</i>
