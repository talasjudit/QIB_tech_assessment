# Path to singularity file
SINGULARITY_FILE="$(pwd)/scripts/genome_singularity.sif"

# Path to input directory
INPUT_DIR="$(pwd)/input"

# Path to output directory
OUTPUT_DIR="$(pwd)/output/02_repeat_analysis"
mkdir -p $OUTPUT_DIR

# Path to log directory
LOG_DIR="$(pwd)/logs/02_repeat_analysis"
mkdir -p $LOG_DIR

#Path to genome query fasta file
GENOME_FILE="$(pwd)/input/genome.fa"

# Paths to the output files
OUTPUT_PAF=$OUTPUT_DIR/genome_self_mapping.paf
REPEATS_FILE=$OUTPUT_DIR/repeats.txt
