#!/bin/bash

# Load the configuration variables
source config/config.sh

# Ensure output and log directories exist
mkdir -p $OUTPUT_DIR $LOG_DIR

# Define the output CSV file
OUTPUT_FILE="${OUTPUT_DIR}/upload_table.csv"

# Log file
LOG_FILE="${LOG_DIR}/generate_table.log"

# Write the header of the CSV file
echo "sampleName,ProjectID,FileForward,FileReverse" > $OUTPUT_FILE

# Loop through all forward read files in the directory
for forward_read in ${READS_DIR}/*_R1.fastq.gz
do
    # Extract the base name of the sample (e.g., sample1 from sample1_R1.fastq.gz)
    sample_name=$(basename $forward_read _R1.fastq.gz)
    
    # Define the path to the reverse read file
    reverse_read="${READS_DIR}/${sample_name}_R2.fastq.gz"
    
    # Check if the reverse read file exists
    if [ -f $reverse_read ]; then
        # Write the sample information to the CSV file
        echo "${sample_name},${PROJECT_ID},${forward_read},${reverse_read}" >> $OUTPUT_FILE
    else
        echo "Warning: Reverse read file for ${sample_name} not found." >> $LOG_FILE
    fi
done

echo "Upload table generated: ${OUTPUT_FILE}" >> $LOG_FILE
