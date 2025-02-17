#!/bin/bash

# Load the configuration variables
source config/03_config.sh

# Ensure the output directories exist
mkdir -p $BLAST_DB_DIR $OUTPUT_DIR $LOG_DIR

# Redirect stdout and stderr to log files
exec 1>>$LOG_DIR/output.log
exec 2>>$LOG_DIR/error.log

# Create a BLAST database from the genome file
singularity exec $SINGULARITY_FILE \
    makeblastdb \
    -in $GENOME_FILE \
    -dbtype nucl \
    -out $BLAST_DB_DIR/genomedb

# Check if the makeblastdb command was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to create BLAST database."
    exit 1
fi

# Run BLAST for gen1
singularity exec $SINGULARITY_FILE \
    blastn \
    -query $GENE1 \
    -db $BLAST_DB_DIR/genomedb \
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
    -query $GENE2 \
    -db $BLAST_DB_DIR/genomedb \
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