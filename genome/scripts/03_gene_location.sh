#!/bin/bash

# Load the configuration variables
source config/03_config.sh

# Ensure the output directories exist
mkdir -p $BLAST_DB_DIR $OUTPUT_DIR $LOG_DIR
mkdir -p $BLAST_DB_DIR/genome_db

# Check if the script has permissions to write in these directories
if [ ! -w $BLAST_DB_DIR ] || [ ! -w $OUTPUT_DIR ] || [ ! -w $LOG_DIR ]; then
    echo "Error: Script does not have write permissions for necessary directories."
    exit 1
fi

# Create a BLAST database from the genome file
singularity exec $SINGULARITY_FILE \
    makeblastdb \
    -in $GENOME_FILE \
    -dbtype nucl \
    -out $BLAST_DB_DIR/genome_db

# Check if the makeblastdb command was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to create BLAST database."
    exit 1
fi

# Run BLAST for gen1
singularity exec $SINGULARITY_FILE \
    blastn \
    -query $GENE1_FILE \
    -db $BLAST_DB_DIR/genome_db \
    -out $OUTPUT_DIR/gen1_blast.txt \
    -outfmt "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore"

# Check if the blastn command for gen1 was successful
if [ $? -ne 0 ]; then
    echo "Error: BLAST search for gen1 failed."
    exit 1
fi

# Run BLAST for gen2
singularity exec $SINGULARITY_FILE \
    blastn \
    -query $GENE2_FILE \
    -db $BLAST_DB_DIR/genome_db \
    -out $OUTPUT_DIR/gen2_blast.txt \
    -outfmt "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore"

# Check if the blastn command for gen2 was successful
if [ $? -ne 0 ]; then
    echo "Error: BLAST search for gen2 failed."
    exit 1
fi

# Extract the start and end positions for gen1
GEN1_LOC=$(awk '{print "Gene: " $1, "Start: " $9, "End: " $10}' $OUTPUT_DIR/gen1_blast.txt)

# Extract the start and end positions for gen2
GEN2_LOC=$(awk '{print "Gene: " $1, "Start: " $9, "End: " $10}' $OUTPUT_DIR/gen2_blast.txt)

# Output the results
echo "$GEN1_LOC"
echo "$GEN2_LOC"

# Save the results to a file
echo "$GEN1_LOC" > $OUTPUT_DIR/gene_locations.txt
echo "$GEN2_LOC" >> $OUTPUT_DIR/gene_locations.txt