#!/bin/bash

# Define the file path
file_path="/hosting/products/jdk/jdk17/conf/security/java.security"

# Get a timestamp in ISO 8601 format
timestamp=$(date +%Y-%m-%dT%H:%M:%S)

# Backup the file with timestamp
backup_file="${file_path}.bak.${timestamp}"
cp "$file_path" "$backup_file"
echo "Created backup: $backup_file"

# Check if the line to update already exists (use grep with -q for quiet mode)
if grep -q 'jdk.tls.disabledAlgorithms' "$file_path"; then
  # Update the existing line with sed (use i for in-place edit)
  sed -i "s/jdk.tls.disabledAlgorithms=.*$/jdk.tls.disabledAlgorithms=SSLv3, TLSv1, TLSv1.1, RC4, DES, MD5withRSA, DH KeySize < 1024, EC KeySize < 1024, 3DES_EDE_CBC, anon, NULL, SHA1, SHA1withRSA, SHA1withDSA/" "$file_path"
  echo "Updated existing line in $file_path"
else
  # Append the line if it doesn't exist with echo
  echo "jdk.tls.disabledAlgorithms=SSLv3, TLSv1, TLSv1.1, RC4, DES, MD5withRSA, DH KeySize < 1024, EC KeySize < 1024, 3DES_EDE_CBC, anon, NULL, SHA1, SHA1withRSA, SHA1withDSA" >> "$file_path"
  echo "Appended line to $file_path"
fi

echo "**Note:** Disabling algorithms might have security implications. Ensure compatibility with your applications before making changes."
