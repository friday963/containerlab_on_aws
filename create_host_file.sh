#!/bin/bash

# Check if an IP address is provided as a command line argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 <ip_address>"
    exit 1
fi

# Get the current directory of the script
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ip_address=$1
pem_file="$script_dir/containerlab-key.pem"
host_file="hosts.ini"

# Check if the PEM file exists
if [ ! -f "$pem_file" ]; then
    echo "Error: PEM file '$pem_file' does not exist."
    exit 1
fi

# Create the host file
echo "[container_lab_instance]" > "$host_file"
echo "$ip_address ansible_user=containerlabuser ansible_ssh_private_key_file=$pem_file" >> "$host_file"

echo "Ansible host file '$host_file' has been created with the IP address: $ip_address"
echo "The PEM file path is: $pem_file"
