resource "aws_cloudformation_stack" "one_click_deployment" {
  name         = "CFANDS3"
  template_url = "https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0026-aws-associate-cdn-cloudfront-and-s3/top10catsbucket.yaml"
  capabilities = ["CAPABILITY_IAM"]
}

resource "aws_cloudfront_distribution" "s3_origin_top10cats" {

  enabled             = true
  default_root_object = "index.html"

  origin {
    domain_name = local.bucket_domain_name
    origin_id   = local.bucket_domain_name
  }

  default_cache_behavior {
    compress               = true
    viewer_protocol_policy = "allow-all"
    allowed_methods        = ["GET", "HEAD"]
    cache_policy_id        = data.aws_cloudfront_cache_policy.managed_caching_optimized.id
    target_origin_id       = local.bucket_domain_name
    cached_methods         = ["GET", "HEAD"]

  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }
}