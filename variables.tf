# Define a variable for the domain name
variable "domain_name" {
  description = "The domain name"
}

# Define a variable for the subdomain name
variable "subdomain_name" {
  description = "The Route53 hosted zone ID"
  type        = string
}

# Define a variable for the region
variable "region" {
  description = "The region name"
}
