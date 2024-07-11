#!/bin/bash

# Load the configuration variables
source config/02_config.sh

# Ensure the output directories exist
mkdir -p $OUTPUT_DIR
mkdir -p $LOG_DIR

# Run minimap2 to map the genome against itself
singularity exec $SINGULARITY_FILE \
    minimap2 \
    -DP \
    -k19 \
    -w19 \
    -m200 \
    $GENOME_FILE $GENOME_FILE > $OUTPUT_PAF

# Check if the minimap2 command was successful
if [ $? -ne 0 ]; then
    echo "Error: minimap2 command failed."
    exit 1
fi

# Parse the PAF file to identify repeats and calculate lengths
awk '
{
    if ($1 == $6 && $3 != $8) {
        repeat_length = ($9 > $4 ? $9 - $3 : $4 - $8);
        print repeat_length;
    }
}' $OUTPUT_PAF > $REPEATS_FILE

# Check if the awk command was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to parse the PAF file."
    exit 1
fi

# Calculate the longest repeat
LONGEST_REPEAT=$(sort -nr $REPEATS_FILE | head -n 1)

# Check if the sort command was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to calculate the longest repeat."
    exit 1
fi

# Count the number of repeats with lengths between 6000 and 7000 base pairs
REPEATS_BETWEEN_6000_7000=$(awk '$1 >= 6000 && $1 <= 7000' $REPEATS_FILE | wc -l)

# Check if the awk command was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to count repeats between 6000 and 7000 base pairs."
    exit 1
fi

# Output the results
echo "Longest repeat size: $LONGEST_REPEAT"
echo "Number of repeats between 6000 and 7000 base pairs: $REPEATS_BETWEEN_6000_7000"

# Save the results to a file
echo "Longest repeat size: $LONGEST_REPEAT" > $OUTPUT_DIR/results.txt
echo "Number of repeats between 6000 and 7000 base pairs: $REPEATS_BETWEEN_6000_7000" >> $OUTPUT_DIR/results.txt

# Check if the results file was created successfully
if [ $? -ne 0 ]; then
    echo "Error: Failed to save the results to a file."
    exit 1
fi