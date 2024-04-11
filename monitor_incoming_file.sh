#!/bin/bash

# Directory where the trigger file is located
folder="/path/to/folder"

# Email address to send the summary
recipient="abc@abc.com"

# Check if the trigger file exists
if [ -f "$folder/<filename>.trg" ]; then
    # Validate the input file and count the number of rows
    input_count=$(wc -l < "$folder/<filename>.txt")

    # Run the Java process
    # Replace "java_process" with the actual command to run your Java process
    java_process_output=$(java_process)

    # Count the number of response files
    response_count=$(find "$folder" -type f -name "<filename>.txt.response" | wc -l)

    # Compare input count with response count
    if [ "$input_count" -eq "$response_count" ]; then
        status="Successful"
    elif [ "$input_count" -gt "$response_count" ]; then
        status="Partial Successful"
    else
        status="Not Ran"
    fi

    # Send email with summary
    echo "Summary:
    - Input File Count: $input_count
    - Java Process Status: $java_process_output
    - Response File Count: $response_count
    - Action Status: $status" | mail -s "Action Summary" "$recipient"
else
    echo "No trigger file found. No action taken."
fi
