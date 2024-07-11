#!/bin/bash

# Load the configuration variables
source config/01_config.sh

# Create directory to store BLAST results
mkdir -p $OUTPUT_DIR/blast_snippet_results

# Temporary files
POSITIONS_FILE="$INPUT_DIR/positions.txt"
SNIPPETS_FILE="$INPUT_DIR/snippets.fasta"

# Get genome length
GENOME_LENGTH=$(singularity exec $SINGULARITY_FILE /bin/bash -c "seqtk seq -A $GENOME_FASTA | awk '!/^>/ {print length(\$0)}' | awk '{sum+=\$1} END {print sum}'")

# Seed for reproducible random generation
SEED=42

# Generate random positions ensuring they are at least 500 bp from the ends
singularity exec $SINGULARITY_FILE /bin/bash -c \
    "awk -v seed=$SEED 'BEGIN{srand(seed); for(i=0; i<10; i++) print int(500 + rand()*($GENOME_LENGTH-1000))}'" > $POSITIONS_FILE

# Extract 10 random 500 bp snippets from the genome using seqtk
singularity exec $SINGULARITY_FILE /bin/bash -c \
    "awk 'NR==FNR{a[\$1]; next} {for(i in a) if(\$1==i) {print \">snippet\" i \"\n\" substr(\$2, a[i], 500)}}' $POSITIONS_FILE <(seqtk seq -A $GENOME_FASTA | paste - -)" > $SNIPPETS_FILE

# Check the content of SNIPPETS_FILE
echo "Snippets extracted:"
cat $SNIPPETS_FILE

# Loop through each snippet and BLAST it
while IFS= read -r line; do
    if [[ $line == \>* ]]; then
        header=$line
        snippet_file=$(mktemp)
        echo "$header" > "$snippet_file"
    else
        echo "$line" >> "$snippet_file"
        
        # Perform remote BLAST search
        singularity exec $SINGULARITY_FILE \
            blastn -query "$snippet_file" \
                   -db nt \
                   -remote \
                   -outfmt "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore staxids" \
                   -max_target_seqs 1 \
                   -out "$OUTPUT_DIR/blast_snippet_results/$(echo $header | tr -d '>').txt"
        rm "$snippet_file"
    fi
done < $SNIPPETS_FILE
