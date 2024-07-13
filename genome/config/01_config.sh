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
BLAST_DB="$(pwd)/input/blastdb/ref_prok_rep_genomes"