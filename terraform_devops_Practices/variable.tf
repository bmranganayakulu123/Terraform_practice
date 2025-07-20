variable "ec2_instance_type" {
    default = "t2.micro"
    type = string
}

variable "ec2_default_root_volume" {
    default = 10
    type = number
}

variable "env" {
  default = "prd"
  type=string
}