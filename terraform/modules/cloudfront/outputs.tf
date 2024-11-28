# output "cloudfront_domain_name" {
#   value = aws_cloudfront_distribution.cdn.domain_name
# }

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.cloudfront.id
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.cloudfront.domain_name
}