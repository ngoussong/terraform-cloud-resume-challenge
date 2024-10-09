# Create S3 bucket
resource "aws_s3_bucket" "s3-bucket" {
  bucket = var.bucket-name
}

#Keeping S3 bucket public
resource "aws_s3_bucket_public_access_block" "website_bucket_access" {
  bucket = aws_s3_bucket.s3-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Define index file 
resource "aws_s3_bucket_website_configuration" "website_bucket_configuration" {
  bucket = aws_s3_bucket.s3-bucket.id

  index_document {
    suffix = "index.html"
  }
}

#Create s3 policyand applying it for s3 bucket
resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = aws_s3_bucket.s3-bucket.id
  policy = data.aws_iam_policy_document.website_bucket.json
}

# Define IAM policy document that allows public access
data "aws_iam_policy_document" "website_bucket" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.s3-bucket.arn}/*",
    ]

    effect = "Allow"
  }
}