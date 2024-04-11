#!/bin/bash

# Directory where trigger files are located
folder="/path/to/folder"

# Email address to send the summary
recipient="abc@abc.com"

# Check for trigger files and process each one
for trigger_file in "$folder"/*.trg; do
    if [ -f "$trigger_file" ]; then
        # Extract filename without extension
        filename=$(basename -- "$trigger_file")
        filename_no_ext="${filename%.*}"

        # Validate and process input file
        input_file="$folder/$filename_no_ext.txt"
        if [ -f "$input_file" ]; then
            input_count=$(wc -l < "$input_file")
            # Run the Java process for the input file
            # Replace "java_process" with the actual command to run your Java process
            java_process_output=$(java_process "$input_file")

            # Count the number of response files
            response_count=$(find "$folder" -type f -name "$filename_no_ext.txt.response" | wc -l)

            # Compare input count with response count
            if [ "$input_count" -eq "$response_count" ]; then
                status="Successful"
            elif [ "$input_count" -gt "$response_count" ]; then
                status="Partial Successful"
            else
                status="Not Ran"
            fi

            # Send email with summary
            echo "Summary for $filename_no_ext:
            - Input File Count: $input_count
            - Java Process Status: $java_process_output
            - Response File Count: $response_count
            - Action Status: $status" | mail -s "Action Summary for $filename_no_ext" "$recipient"
        else
            echo "Input file not found for $trigger_file. No action taken."
        fi
    fi
done
