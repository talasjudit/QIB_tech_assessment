#!/bin/bash

# Directory containing alignment files
ALIGNMENT_DIR="$(pwd)/002.iqtree_question"

# Directory containing log files
LOG_DIR="$(pwd)/logs"

# Output directory
OUTPUT_DIR="$(pwd)/output"

# Singularity container location
SINGULARITY_FILE="$(pwd)/scripts/iqtree_singularity.sif"

# Environment file
ENV_FILE="$(pwd)/scripts/env.list"

# Create the environment file
cat <<EOL > $ENV_FILE
ALIGNMENT_DIR=$ALIGNMENT_DIR
LOG_DIR=$LOG_DIR
OUTPUT_DIR=$OUTPUT_DIR
EOL
