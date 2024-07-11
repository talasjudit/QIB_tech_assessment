#!/bin/bash

# Load the configuration variables
source config/01_config.sh

mkdir -p $INPUT_DIR/kraken_db

singularity exec $SINGULARITY_FILE \
    kraken2-build \
    --standard \
    --db $INPUT_DIR/kraken_db

mkdir -p $OUTPUT_DIR/kraken

singularity exec $SINGULARITY_FILE \
    kraken2 \
    --db $INPUT_DIR/kraken_db \
    --threads 4 \
    --report $OUTPUT_DIR/kraken/kraken_db_output.report $GENOME_FASTA > $OUTPUT_DIR/kraken/output.kraken
