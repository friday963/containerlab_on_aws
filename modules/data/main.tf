data "aws_ip_ranges" "region_specific_instance_connect" {
  regions = [var.region]
  services = ["ec2_instance_connect"]
}

data "http" "get_public_ip_address" {
  url = "https://ipv4.icanhazip.com/"
  request_timeout_ms = "30000"
  retry {
    attempts = 3
  }
}

locals {
    parsed_data = chomp(data.http.get_public_ip_address.response_body)
    ip_address = local.parsed_data
}