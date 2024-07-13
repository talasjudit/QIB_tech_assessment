#!/bin/bash

# Load the configuration variables
source config/01_config.sh

# Create directories to store BLAST results and temporary snippet files
mkdir -p $OUTPUT_DIR/blast_snippet_results
SNIPPETS_DIR="$OUTPUT_DIR/snippets"
mkdir -p $SNIPPETS_DIR

# Temporary files
POSITIONS_FILE="$INPUT_DIR/positions.txt"
LOG_FILE="$LOG_DIR/blast_errors.log"

# Get genome length
GENOME_LENGTH=$(singularity exec $SINGULARITY_FILE /bin/bash -c "seqtk seq -A $GENOME_FASTA | awk 'NR>1 {print length(\$0)}' | awk '{sum+=\$1} END {print sum}'")

# Seed for reproducible random generation
SEED=42

# Generate random positions ensuring they are at least 500 bp from the ends - not important in this case but good practice for full chromosome level genomes
singularity exec $SINGULARITY_FILE /bin/bash -c \
    "awk -v seed=$SEED -v gen_len=$GENOME_LENGTH 'BEGIN{srand(seed); for(i=0; i<10; i++) print int(500 + rand()*(gen_len-1000))}'" > $POSITIONS_FILE

# Extract 10 random 500 bp snippets from the genome using seqtk and save each in its own file
while read -r pos; do
    start_pos=$pos 
    end_pos=$((pos+499))
    snippet_file="${SNIPPETS_DIR}/snippet_${pos}-${end_pos}.fasta" 
    echo ">snippet_$pos-$end_pos" > "$snippet_file" # Write header to the snippet file
    echo -e "unknown\t$start_pos\t$end_pos" > temp.bed
    singularity exec $SINGULARITY_FILE /bin/bash -c \
        "seqtk subseq $GENOME_FASTA temp.bed" | tail -n +2 >> "$snippet_file" # Append sequence to the snippet file
done < $POSITIONS_FILE

# Clean up temporary BED file
rm temp.bed

run_blast_for_snippet() {
    snippet_file="$1" # The first argument is now the path to the snippet file
    header=$(head -n 1 "$snippet_file") # Extract the header from the file
    sequence=$(tail -n +2 "$snippet_file") # Extract the sequence from the file
    blast_output="${OUTPUT_DIR}/blast_snippet_results/$(basename "$snippet_file" .fasta)_blast.txt"

    echo "Running BLAST for $header..."
    if singularity exec $SINGULARITY_FILE blastn -query "$snippet_file" -db $BLAST_DB \
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
}

export -f run_blast_for_snippet
export LOG_FILE BLAST_DB SINGULARITY_FILE OUTPUT_DIR

# Use parallel to find all .fasta files starting with 'snippet' and run BLAST for each
find "$SNIPPETS_DIR" -name 'snippet*.fasta' | parallel -j $(nproc) run_blast_for_snippet
