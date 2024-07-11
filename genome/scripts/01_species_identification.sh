#!/bin/bash

# Load the configuration variables
source config/01_config.sh

# Create a log file
LOG_FILE="$LOG_DIR/blast_log.txt"

# Run BLAST to identify the species using NCBI remote database within Singularity
singularity exec $SINGULARITY_FILE blastn \
    -query $GENOME_FASTA \
    -db $BLAST_DB \
    -remote \
    -out $OUTPUT_DIR/blast_results.txt \
    -outfmt '6 std staxids' \
    -max_target_seqs 1 \
    &> $LOG_FILE

echo "Species identification results are saved in $LOG_DIR/blast_results.txt"
echo "Log file is saved in $LOG_FILE"
