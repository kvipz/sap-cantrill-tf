resource "aws_cloudformation_stack" "one_click_deployment" {
  name         = "CFANDS3"
  template_url = "https://learn-cantrill-labs.s3.amazonaws.com/awscoursedemos/0026-aws-associate-cdn-cloudfront-and-s3/top10catsbucket.yaml"
  capabilities = ["CAPABILITY_IAM"]
}