# key pair 
resource "aws_key_pair" "my_key" {
  key_name   = "${var.env}-infra_app_key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILkk4QoaDvzlVq90oePVLHLeUwRE8u47pu2E+D9byW/w nvohra@DESKTOP-5OTETF0ls"


  tags = {
    "Environment" = var.env
  }
}

# Default  Vpc 
resource "aws_default_vpc" "default" {

}
#and seccurity groups 
resource "aws_security_group" "my_sg" {
  name        = "${var.env}-infra_app_sg"
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
    Name = "${var.env}-infra_app_sg"
  }

}
# ec2 instance 
resource "aws_instance" "web" {

count = var.instance_count
  ami           = var.ec2_ami_id
  instance_type = var.instance_type
  key_name = aws_key_pair.my_key.key_name
  security_groups = [ aws_security_group.my_sg.name]

root_block_device {
  volume_size = var.env == "prd" ? 20 : 10
  volume_type = "gp3"
}

  tags = {
    Name = "${var.env}-infra_app_instance"
  }
}