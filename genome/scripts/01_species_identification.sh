#!/bin/bash

# Load the configuration variables
source config/01_config.sh

# Ensure the log and output directories exist
mkdir -p $LOG_DIR
mkdir -p $OUTPUT_DIR

# Function to run BLAST
run_blast() {
    local chunk=$1
    local result_file=$2
    local log_file=$3
    local error_log_file=$4

    echo "Running BLAST on $chunk" >> $log_file

    singularity exec $SINGULARITY_FILE \
        blastn \
        -query $chunk \
        -db $BLAST_DB \
        -out $result_file \
        -outfmt '6 std staxids' \
        -max_target_seqs 1 \
        >> $log_file 2>> $error_log_file

    echo "Finished BLAST on $chunk" >> $log_file
}

export -f run_blast
export SINGULARITY_FILE BLAST_DB OUTPUT_DIR LOG_DIR

# Configuration variables
chunk_size="50000"
chunk_prefix="genome_chunk"

# Read the header
header=$(head -n 1 "$GENOME_FASTA")

# Concatenate the sequence lines into one continuous string
sequence=$(tail -n +2 "$GENOME_FASTA" | tr -d '\n')

# Calculate the number of chunks
sequence_length=${#sequence}
num_chunks=$((sequence_length / chunk_size + (sequence_length % chunk_size > 0)))

# Split the sequence and save to files
for ((i=0; i<num_chunks; i++)); do
    start=$((i * chunk_size))
    chunk=${sequence:$start:$chunk_size}
    chunk_file="${INPUT_DIR}/${chunk_prefix}_${i}.fa"
    echo "$header" > "$chunk_file"
    echo "$chunk" >> "$chunk_file"
done

# Run BLAST in parallel on each chunk and create individual log files
find $INPUT_DIR -name "${chunk_prefix}_*.fa" | parallel \
    --jobs $(nproc) \
    run_blast {} $OUTPUT_DIR/{/.}_blast_results.txt $LOG_DIR/{/.}_blast_log.txt $LOG_DIR/{/.}_blast_error_log.txt

wait

# Combine all results into one file
cat $OUTPUT_DIR/*_blast_results.txt > $OUTPUT_DIR/blast_results.txt

# Combine all stdout logs into one file
cat $LOG_DIR/*_blast_log.txt > $LOG_DIR/consolidated_blast_log.txt

# Combine all stderr logs into one file
cat $LOG_DIR/*_blast_error_log.txt > $LOG_DIR/consolidated_blast_error_log.txt

# Clean up individual result and log files
rm $OUTPUT_DIR/*_blast_results.txt
rm $LOG_DIR/*_blast_log.txt
rm $LOG_DIR/*_blast_error_log.txt

echo "Species identification results are saved in $OUTPUT_DIR/blast_results.txt"
echo "Consolidated log file is saved in $LOG_DIR/consolidated_blast_log.txt"
echo "Consolidated error log file is saved in $LOG_DIR/consolidated_blast_error_log.txt"