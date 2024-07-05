locals {
  website_endpoint   = aws_cloudformation_stack.one_click_deployment.outputs["WebsiteEndPoint"]
  bucket_name        = split(".", split("/", local.website_endpoint)[2])[0]
  bucket_domain_name = "${local.bucket_name}.s3.us-east-1.amazonaws.com"
}

data "aws_cloudfront_cache_policy" "managed_caching_optimized" {
  name = "Managed-CachingOptimized"
}