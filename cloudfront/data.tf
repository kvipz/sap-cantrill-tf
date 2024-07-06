locals {
  website_endpoint   = aws_cloudformation_stack.one_click_deployment.outputs["WebsiteEndPoint"]
  bucket_name        = split(".", split("/", local.website_endpoint)[2])[0]
  bucket_domain_name = "${local.bucket_name}.s3.us-east-1.amazonaws.com"
  custom_domain_name = "merlin.feets2cloud.com"  # Change this with your own domain name
}

data "aws_cloudfront_cache_policy" "managed_caching_optimized" {
  name = "Managed-CachingOptimized"
}

data "aws_route53_zone" "feets2cloud" {
  name         = "feets2cloud.com"
  private_zone = false
}