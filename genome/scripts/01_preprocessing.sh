#!/bin/bash

# Load the configuration variables
source config/01_config.sh

# Function to split a long sequence into smaller chunks
split_fasta() {
    local fasta_file=$1
    local chunk_size=$2
    local output_dir=$3
    local output_prefix=$4

    # Extract the header
    local header=$(grep "^>" $fasta_file)

    # Remove the header and join the sequence into a single line
    local sequence=$(grep -v "^>" $fasta_file | tr -d '\n')

    # Calculate the length of the sequence
    local seq_length=${#sequence}

    # Split the sequence into chunks
    local start=1
    local chunk_number=1

    while [ $start -le $seq_length ]; do
        local end=$((start + chunk_size - 1))
        if [ $end -gt $seq_length ]; then
            end=$seq_length
        fi
        local chunk=$(echo $sequence | awk -v start=$start -v end=$end '{print substr($0, start, end - start + 1)}')
        printf "%s\n%s\n" "$header chunk $chunk_number" "$chunk" > "${output_dir}/${output_prefix}_chunk_${chunk_number}.fa"
        start=$((start + chunk_size))
        chunk_number=$((chunk_number + 1))
    done
}

# Specify the chunk size (e.g., 10,000 bp)
CHUNK_SIZE=30000

# Ensure the input directory exists
mkdir -p $INPUT_DIR

# Split the genome FASTA file into smaller chunks and save them in the input directory
split_fasta $GENOME_FASTA $CHUNK_SIZE $INPUT_DIR "genome"

echo "FASTA file has been split into chunks and saved in $INPUT_DIR"