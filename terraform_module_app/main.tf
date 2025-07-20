module "dev-infra" {
    source = "./infra-app"
    env ="dev"
    bucket_name ="devlopment-bucket"
    instance_count=1
    instance_type="t2.micro"
    ec2_ami_id= "ami-0d1b5a8c13042c939"
    hash_key="Student_ID"    

  
}