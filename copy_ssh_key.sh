#!/bin/bash

# Path to the input file
INPUT_FILE="output.txt"  # Replace with your actual file name

# Extract IPs from the vm_public_ips array in the file
vm_ips=$(awk '/vm_public_ips = \[/{flag=1; next} /\]/{flag=0} flag' "$INPUT_FILE" | sed -e 's/[",]//g' -e '/^\s*$/d')

# Check if IPs were found
if [ -z "$vm_ips" ]; then
  echo "No vm_public_ips found in the file."
  exit 1
fi

# Path to private key
KEY_PATH="$HOME/.ssh/id_rsa"

# Copy the SSH key to each VM
for ip in $vm_ips; do
  echo "Copying SSH key to $ip..."
  scp -i "$KEY_PATH" "$KEY_PATH" "azureuser@$ip:."
done

