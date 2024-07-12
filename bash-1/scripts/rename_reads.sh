#!/bin/bash

# Load the configuration
source config/config.sh

# Log file
LOG_FILE="${LOG_DIR}/rename.log"

# Function to log messages
log_message() {
    local message=$1
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" >> $LOG_FILE
}

# Log the start of the process
log_message "Starting the file renaming process."

# Function to rename files consistently
rename_files() {
    local directory=$1
    for file in ${directory}/*_R1.*.gz
    do
        # Skip if no files match the pattern
        if [[ ! -e $file ]]; then
            continue
        fi

        # Determine the new name for the forward read
        new_forward=$(echo $file | sed -E 's/_R1\.[a-zA-Z]+\.gz/_R1.fastq.gz/')
        
        # Skip renaming if the file already has the desired name
        if [[ "$file" == "$new_forward" ]]; then
            log_message "Skipping renaming for $file as it already matches the target name."
            continue
        fi

        # Log the renaming action
        log_message "Renaming forward read file: $file to $new_forward"

        # Rename the forward read file
        mv "$file" "$new_forward"

        # Determine the corresponding reverse read file
        reverse_file=$(echo $file | sed -E 's/_R1\./_R2./')
        new_reverse=$(echo $reverse_file | sed -E 's/_R2\.[a-zA-Z]+\.gz/_R2.fastq.gz/')

        # Skip renaming if the reverse read file already has the desired name
        if [[ -e $reverse_file ]]; then
            if [[ "$reverse_file" == "$new_reverse" ]]; then
                log_message "Skipping renaming for $reverse_file as it already matches the target name."
            else
                log_message "Renaming reverse read file: $reverse_file to $new_reverse"
                mv "$reverse_file" "$new_reverse"
            fi
        else
            log_message "Warning: Reverse read file for $(basename $file) not found."
        fi
    done
}

# Run the renaming function
rename_files $READS_DIR

# Log the end of the process
log_message "File renaming process completed."