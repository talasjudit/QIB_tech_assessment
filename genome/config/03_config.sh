# Path to singularity file
SINGULARITY_FILE="$(pwd)/scripts/genome_singularity.sif"

# Path to input directory
INPUT_DIR="$(pwd)/input"

# Path to output directory
OUTPUT_DIR="$(pwd)/output/03_gene_location"
mkdir -p $OUTPUT_DIR

# Path to log directory
LOG_DIR="$(pwd)/logs/03_gene_location"
mkdir -p $LOG_DIR

#Path to genome and gene fasta files
GENOME_FILE="$(pwd)/input/genome.fa"
GENE1="$(pwd)/input/gen1.fa"
GENE2="$(pwd)/input/gen2.fa"

# Path to BLAST database directory
BLAST_DB="$(pwd)/input/blastdb"
