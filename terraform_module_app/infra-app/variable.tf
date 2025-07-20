variable "env" {
    description = "This is the environment to my instance "
    type =string
}

variable "bucket_name" {
    description ="This is the buckeyt name for my infra"
    type = string
  
}
variable "instance_count" {
    description = "This is the no.of ec2 instance"
    type=number
  
}
variable "instance_type" {
    description = "This is the type of instance"
    type = string
}
variable "ec2_ami_id" {
    description = "This the instance ami id"
    type = string
  
}
variable "hash_key" {
    description = "This is the hash key for dynamodb infra-app"
    type = string
  
}
