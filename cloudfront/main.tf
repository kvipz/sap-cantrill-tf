resource "aws_cloudformation_stack" "one_click_deployment" {
  name         = "CFANDS3"
  template_url = "https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0026-aws-associate-cdn-cloudfront-and-s3/top10catsbucket.yaml"
  capabilities = ["CAPABILITY_IAM"]
}

resource "aws_cloudfront_distribution" "s3_origin_top10cats" {

  enabled             = true
  default_root_object = "index.html"
  aliases             = [local.custom_domain_name]

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
    cloudfront_default_certificate = false
    acm_certificate_arn            = aws_acm_certificate.merlin.arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }
}

resource "aws_acm_certificate" "merlin" {
  domain_name       = local.custom_domain_name
  validation_method = "DNS"
}

resource "aws_route53_record" "merlin_acm_validation" {
  for_each = {
    for dvo in aws_acm_certificate.merlin.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.feets2cloud.zone_id
}

resource "aws_acm_certificate_validation" "merlin" {
  certificate_arn         = aws_acm_certificate.merlin.arn
  validation_record_fqdns = [for record in aws_route53_record.merlin_acm_validation : record.fqdn]
}

resource "aws_route53_record" "merlin" {
  zone_id = data.aws_route53_zone.feets2cloud.id
  name    = "merlin.feets2cloud.com"
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.s3_origin_top10cats.domain_name
    zone_id                = aws_cloudfront_distribution.s3_origin_top10cats.hosted_zone_id
    evaluate_target_health = true
  }
}