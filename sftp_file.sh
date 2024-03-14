#!/bin/bash

# Directory where .response files are located
source_dir="/path/to/source/directory"

# Remote server details
remote_user="username"
remote_host="remote.hostname.com"
remote_path="/path/to/remote/directory"

# Function to transfer .response files using sftp
transfer_files() {
  local file="$1"
  sftp "${remote_user}@${remote_host}" <<EOF
cd "${remote_path}"
put "${file}"
bye
EOF
}

# Main script
echo "Checking for .response files in ${source_dir}..."
for file in "${source_dir}"/*.response; do
  if [ -f "$file" ]; then
    echo "Transferring file: $file"
    transfer_files "$file"
    # Optional: Move or delete the file after transfer
    # mv "$file" /path/to/backup/directory/
    # rm "$file"
  else
    echo "No .response files found."
  fi
done
