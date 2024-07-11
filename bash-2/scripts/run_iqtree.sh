#!/bin/bash

set -x

# Load the configuration variables
source config/config.sh

# Ensure output and log directories exist
mkdir -p "$OUTPUT_DIR" "$LOG_DIR"

# Debug: Echo the Singularity file path and env file path
echo "Using Singularity image: $SINGULARITY_FILE"
echo "Using environment file: $ENV_FILE"

# Check if the Singularity container image exists
if [[ ! -f "$SINGULARITY_FILE" ]]; then
    echo "Error: Singularity container image '$SINGULARITY_FILE' does not exist." >&2
    exit 1
fi

# Check if the environment file exists and display its content
if [[ ! -f "$ENV_FILE" ]]; then
    echo "Error: Environment file '$ENV_FILE' does not exist." >&2
    exit 1
fi
echo "Content of $ENV_FILE:"
cat "$ENV_FILE"

# Function to run iqtree2 on a single alignment file
run_iqtree() {
    local aln_file=$1
    local prefix=$(basename "$aln_file" .aln)

    # Debug: Echo the environment variables
    echo "ALIGNMENT_DIR=$ALIGNMENT_DIR"
    echo "LOG_DIR=$LOG_DIR"
    echo "OUTPUT_DIR=$OUTPUT_DIR"
    echo "SINGULARITY_FILE=$SINGULARITY_FILE"

    # Check if the alignment file exists
    if [[ ! -f "$aln_file" ]]; then
        echo "Error: Alignment file '$aln_file' does not exist." >&2
        return 1
    fi

    # Debug: Echo the alignment file being processed
    echo "Processing alignment file: $aln_file"

    # Run iqtree2 and capture errors
    singularity exec "$SINGULARITY_FILE" iqtree2 -s "$aln_file" --prefix "$OUTPUT_DIR/$prefix" -m HKY+G > "$LOG_DIR/$prefix.stdout.log" 2> "$LOG_DIR/$prefix.stderr.log"

    # Check if iqtree2 executed successfully
    if [[ $? -ne 0 ]]; then
        echo "Error: iqtree2 failed for '$aln_file'. Check '$LOG_DIR/$prefix.stderr.log' for details." >&2
        return 1
    fi
}

# Export the function and necessary variables
export -f run_iqtree
export LOG_DIR
export OUTPUT_DIR
export SINGULARITY_FILE

# Iterate through all alignment files sequentially
for aln_file in "$ALIGNMENT_DIR"/*.aln; do
    if [[ -f "$aln_file" ]]; then
        run_iqtree "$aln_file"
    fi
done
