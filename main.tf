# main.tf

# Define the Route53 module
module "Route53" {
  # Set the source to the local path of the Route_53 module
  source = "./modules/Route_53"

  # Pass the domain_name variable to the Route_53 module
  domain_name = var.domain_name

  # Pass the subdomain_name variable to the Route_53 module
  subdomain_name = var.subdomain_name

  # Pass the region variable to the Route_53 module
  region = var.region
}
