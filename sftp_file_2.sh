#!/bin/bash

# Directory where .response files are located
source_dir="/path/to/source/directory"

# Remote server details
remote_user="username"
remote_host="remote.hostname.com"
remote_path="/path/to/remote/directory"

# Function to check if the corresponding response file has not been modified for more than 1 minute
response_file_not_modified() {
  local response_file="$1"
  local input_file="${response_file%.response}.txt"  # Get corresponding input file
  if [ -f "$input_file" ]; then
    echo "Checking if response file has not been modified: $response_file"
    # Get the last modification time of the response file in seconds since the epoch
    last_modified=$(stat -c %Y "$response_file")
    # Get the current time in seconds since the epoch
    current_time=$(date +%s)
    # Calculate the time difference in seconds
    time_diff=$((current_time - last_modified))
    # Check if the time difference is more than 60 seconds (1 minute)
    if [ "$time_diff" -gt 60 ]; then
      echo "Response file has not been modified for more than 1 minute: $response_file"
      return 0  # Response file has not been modified for more than 1 minute
    else
      echo "Response file has been modified within the last 1 minute: $response_file"
      return 1  # Response file has been modified within the last 1 minute
    fi
  else
    echo "Input file does not exist for response file: $response_file"
    return 2  # Input file does not exist
  fi
}

# Function to transfer .response files using sftp
transfer_files() {
  local file="$1"
  echo "Transferring file: $file"
  transfer_status=$(transfer_files "$file")  # Assuming transfer_files function returns a status
  if [ "$transfer_status" -eq 0 ]; then
    echo "Transfer successful: $file"
    # Optional: Move or delete the file after successful transfer
    # mv "$file" /path/to/backup/directory/
    # rm "$file"
  else
    echo "Transfer failed: $file"
    # Handle transfer failure as needed
  fi
}

# Main script
echo "Checking for .response files in ${source_dir}..."
for file in "${source_dir}"/*.response; do
  if [ -f "$file" ]; then
    if response_file_not_modified "$file"; then
      transfer_files "$file"
    else
      echo "Skipping transfer of $file: Corresponding response file modified within the last 1 minute or input file does not exist."
    fi
  else
    echo "No .response files found."
  fi
done
