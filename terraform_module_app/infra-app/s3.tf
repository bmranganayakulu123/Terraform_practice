resource "aws_s3_bucket" "example" {
  bucket = "${var.env}-${var.bucket_name}"

  tags = {
    "Name" = "make-dev-bucket"
    Environment=var.env
  }
}
