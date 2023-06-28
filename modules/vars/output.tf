output "instance_connect_results" {
    value = data.aws_ip_ranges.region_specific_instance_connect.cidr_blocks[0]
}

output "home_ip_address" {
    value = local.ip_address
}