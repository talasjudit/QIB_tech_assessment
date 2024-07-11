#!/bin/bash

# Load the configuration variables
source config/config.sh

# Ensure output and log directories exist
mkdir -p "$OUTPUT_DIR" "$LOG_DIR"

# Check if the Singularity container image exists
if [[ ! -f "$SINGULARITY_FILE" ]]; then
    echo "Error: Singularity container image '$SINGULARITY_FILE' does not exist." >&2
    exit 1
fi

# Check if the environment file exists
if [[ ! -f "$ENV_FILE" ]]; then
    echo "Error: Environment file '$ENV_FILE' does not exist." >&2
    exit 1
fi

# Function to run iqtree2 on a single alignment file
run_iqtree() {
    local aln_file=$1
    local prefix=$(basename "$aln_file" .aln)

    # Echo the alignment file being processed
    echo "Processing alignment file: $aln_file"

    # Run iqtree2 in singularity container
    singularity exec \
        --env-file "$ENV_FILE" \
        "$SINGULARITY_FILE" \
        iqtree2 \
            -s "$aln_file" \
            --prefix "$OUTPUT_DIR/$prefix" \
            -m HKY+G \
            > "$LOG_DIR/$prefix.stdout.log" \
            2> "$LOG_DIR/$prefix.stderr.log"
}

# Export the function and necessary variables
export -f run_iqtree
export LOG_DIR
export OUTPUT_DIR
export SINGULARITY_FILE

# Run iqtree2 on all alignment files in parallel, with closed terminal support
nohup bash -c "find '$ALIGNMENT_DIR' -name '*.aln' | parallel -j '$(nproc)' run_iqtree" > $LOG_DIR/iqtree2_run.log 2>&1 &

echo "iqtree2 processing started in the background. Check $LOG_DIR/iqtree2_run.log for progress."
