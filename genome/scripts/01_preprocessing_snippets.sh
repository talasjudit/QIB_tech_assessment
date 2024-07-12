#!/bin/bash

# Load the configuration variables
source config/01_config.sh

# Create directories to store BLAST results and temporary snippet files
mkdir -p $OUTPUT_DIR/blast_snippet_results
SNIPPETS_DIR="$OUTPUT_DIR/snippets"
mkdir -p $SNIPPETS_DIR

# Temporary files
POSITIONS_FILE="$INPUT_DIR/positions.txt"
SNIPPETS_FILE="$INPUT_DIR/snippets.fasta"
LOG_FILE="$LOG_DIR/blast_errors.log"

# Get genome length
GENOME_LENGTH=$(singularity exec $SINGULARITY_FILE /bin/bash -c "seqtk seq -A $GENOME_FASTA | awk 'NR>1 {print length(\$0)}' | awk '{sum+=\$1} END {print sum}'")

# Seed for reproducible random generation
SEED=42

# Generate random positions ensuring they are at least 500 bp from the ends
singularity exec $SINGULARITY_FILE /bin/bash -c \
    "awk -v seed=$SEED -v gen_len=$GENOME_LENGTH 'BEGIN{srand(seed); for(i=0; i<10; i++) print int(500 + rand()*(gen_len-1000))}'" > $POSITIONS_FILE

# Extract 10 random 500 bp snippets from the genome using seqtk
{
    # Print each position and extract the snippet
    while read -r pos; do
        start_pos=$pos 
        end_pos=$((pos+499))
        echo ">snippet_$pos-$end_pos"
        echo -e "unknown\t$start_pos\t$end_pos" > temp.bed
        singularity exec $SINGULARITY_FILE /bin/bash -c \
            "seqtk subseq $GENOME_FASTA temp.bed" | tail -n +2
    done < $POSITIONS_FILE
} > $SNIPPETS_FILE

# Clean up the temporary BED file
rm temp.bed

# Function to extract and run BLAST for each snippet
run_blast_for_snippet() {
    local header=$1
    local sequence=$2
    local snippet_file="$SNIPPETS_DIR/$(echo $header | tr -d '>').fasta"
    local blast_output="$OUTPUT_DIR/blast_snippet_results/$(echo $header | tr -d '>').txt"

    # Create a temporary file for the snippet
    echo "$header" > "$snippet_file"
    echo "$sequence" >> "$snippet_file"

    # Run BLAST
    echo "Running BLAST for $header..."
    if singularity exec $SINGULARITY_FILE blastn -query "$snippet_file" -db $BLAST_DB_DIR/my_local_db \
        -outfmt "6 std staxids" \
        -max_target_seqs 1 -out "$blast_output" 2>> $LOG_FILE; then
        if [[ -s "$blast_output" ]]; then
            echo "BLAST results for $header saved to $blast_output"
            cat "$blast_output"
        else
            echo "No BLAST results for $header. Possible issue with BLAST query or database."
        fi
    else
        echo "BLAST command failed for $header. Check $LOG_FILE for errors."
    fi

    # Remove the temporary snippet file
    rm "$snippet_file"
}

# Read the snippets file and process each snippet
{
    while read -r header; do
        read -r sequence
        run_blast_for_snippet "$header" "$sequence"
    done
} < $SNIPPETS_FILE
