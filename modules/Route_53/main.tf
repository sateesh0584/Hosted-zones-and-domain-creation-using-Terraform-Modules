# Define the Route53 zone for the domain "harifamily.net"
resource "aws_route53_zone" "my_zone" {
  name = "harifamily.net"
}

# Define an A record for the domain "harifamily.net" pointing to IP address 1.2.3.4
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.my_zone.zone_id
  name    = "harifamily.net"
  type    = "A"
  ttl     = "300"
  records = ["1.2.3.4"]
}

# Define an ACM certificate for the domain "harifamily.net" with DNS validation method
resource "aws_acm_certificate" "cert" {
  domain_name       = "harifamily.net"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# Define local variables for certificate validation options
locals {
  cert_validation_options = {
    # Retrieve the first domain validation option if available
    "cert_validation_option_1": length(aws_acm_certificate.cert.domain_validation_options) > 0 ? element(tolist(aws_acm_certificate.cert.domain_validation_options), 0).resource_record_name : null
  }
}

# Define Route53 records for certificate validation
resource "aws_route53_record" "cert_validation" {
  for_each = local.cert_validation_options

  zone_id  = aws_route53_zone.my_zone.zone_id
  name     = each.value
  type     = "CNAME"
  records  = ["harifamily.net"]  
  ttl      = "300"
}

# Define a null resource to wait for certificate validation
resource "null_resource" "wait_for_cert_validation" {
  provisioner "local-exec" {
    # Wait for 301 seconds before completing the provisioner
    command = "ping 127.0.0.1 -n 301 > nul"  
  }

  # Wait for the certificate validation Route53 records to be created before executing
  depends_on = [aws_route53_record.cert_validation]
}
