#key pair
resource "aws_key_pair" "deployer" {
  key_name   = "terra_key"
  public_key = file("terra_key.pub")
}
#vpc
resource "aws_default_vpc" "default" {
 
}
#security Group
resource "aws_security_group" "my_sg" {
     name        = "automate_sg"
    description = "Allow TLS inbound traffic and all outbound traffic"
    vpc_id      = aws_default_vpc.default.id#interpolation


    #inboundrules
    ingress{
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "ssh open"    
    }
    ingress{
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "HTTP open"
    }
    ingress{
        from_port = 8000
        to_port = 8000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "flask app"
    }
    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "all access open outbound rules"

    }
    tags = {
         Name = "auto-sg"
    }

}
#ec2
resource "aws_instance" "my_instance" {
     for_each = tomap({
        terra_server1 = "t2.micro"
        terra_mohan2 ="t2.micro"
  })
  ami           = "ami-09e6f87a47903347c"
  instance_type = each.value
  key_name      = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.my_sg.name]

  root_block_device {
    volume_size = var.ec2_volume_size
    volume_type = "gp3"
  }
  tags = {
    Name = each.key
  }
}

