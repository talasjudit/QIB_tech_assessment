#!/bin/bash

# Create input directory if it doesn't exist
mkdir -p input

# Download the Metadata table
wget -O input/metadata.csv https://raw.githubusercontent.com/quadram-institute-bioscience/datasciencegroup/main/2_rarefaction/metadata.csv

# Download the Abundance table
wget -O input/table.csv https://raw.githubusercontent.com/quadram-institute-bioscience/datasciencegroup/main/2_rarefaction/table.csv

# Download the Taxonomy table
wget -O input/taxonomy.csv https://raw.githubusercontent.com/quadram-institute-bioscience/datasciencegroup/main/2_rarefaction/taxonomy.csv

echo "All files downloaded successfully."
