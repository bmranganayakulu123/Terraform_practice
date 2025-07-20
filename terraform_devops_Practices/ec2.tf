# key pair 
resource "aws_key_pair" "my_key" {
  key_name   = "devops_practices"
  public_key = file("devops_practices.pub")
}

# Default  Vpc 
resource "aws_default_vpc" "default" {

}
#and seccurity groups 
resource "aws_security_group" "my_sg" {
  name        = "ec2_sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_default_vpc.default.id #interpolation
  
  # inbound 
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    description = "open ssh"
    
  }
   ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "HTTP open"  
  }
  ingress {
    from_port        = 8000
    to_port          = 8000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "Flask app"  
  }
  #outbound rules
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    description = "all access outbound rules "  
  }
 tags = {
    Name = "ec2_sg"
  }

}
# ec2 instance 
resource "aws_instance" "web" {
for_each = tomap({
devops_Practices_01="t2.micro"
devops_Practices_02="t2.medium"

})
  ami           = "ami-020cba7c55df1f615"
  instance_type = each.value
  key_name = aws_key_pair.my_key.key_name
  security_groups = [ aws_security_group.my_sg.name]

root_block_device {
  volume_size = var.env == "prd" ? 20 : var.ec2_default_root_volume
  volume_type = "gp3"
}

  tags = {
    Name = each.key
  }
}

/*resource "aws_instance" "my_new_instance" {
 
}*/