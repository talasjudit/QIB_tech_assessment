# Path to singularity file
SINGULARITY_FILE="$(pwd)/scripts/genome_singularity.sif"

# Path to input directory
INPUT_DIR="$(pwd)/input"

# Path to output directory
OUTPUT_DIR="$(pwd)/output/01_species_identification"
mkdir -p $OUTPUT_DIR

# Path to log directory
LOG_DIR="$(pwd)/logs/01_species_identification"
mkdir -p $LOG_DIR

#Path to genome query fasta file
GENOME_FASTA="$(pwd)/input/genome.fa"

#BLAST database to use
BLAST_DB="nt"

# Environment file
ENV_FILE="$(pwd)/scripts/env.list"

# Create the environment file
cat <<EOL > $ENV_FILE
INPUT_DIR=$INPUT_DIR
LOG_DIR=$LOG_DIR
OUTPUT_DIR=$OUTPUT_DIR
BLAST_DB=$BLAST_DB
GENOME_FASTA=$GENOME_FASTA
EOL
