# Genome Analysis

## Q1. Species Identification

Identify the species to which the given genome belongs.

**1. Navigate to starting directory and prerequisites**

1. Assuming you starting from parent directory `QIB_TECH_ASSESSMENT`, navigate to `genome` subdirectory

2. This solution assumes that you have a local BLAST database. For this solution I used the ref_prok_rep_genomes database but feel free to modify the script for a remote alignment or use an alternative database, to edit the database directory please refer to `config/01_config.sh` and edit the `$BLAST_DB_DIR ` environment variable path. To download the relevant BLAST database I used the following command:

```
cd input/blastdb
singularity exec ../scripts/genome_singularity.sif \
    update_blastdb.pl --decompress ref_prok_rep_genomes
```
3. This solution also assumes that you have singularity installed on your system and that you have compiled singularity container `genome_singularity.sif` by executing:
```
sudo singularity build ./scripts/genome_singularity.sif ./scripts genome_singularity.def
```

4. Finally this solution also assumes that you have GNU parallel downloaded on your system.

These prerequisites are also assumed for Q2 and Q3.

For all questions I have left the relevant output .txt files in the `output` folder for a quick reference.

**2. Quick preprocessing to identify database type**

It is time consuming to run a BLAST search using the whole genome as a query without any context. To get context I decided to randomly sample my genome to get 10 x 500bp queries and run this against my database.

Execute preprocessing script after returning to the genome directory

```
./scripts/01_preprocessing_snippets.sh
```

Inspect the output of the BLAST search in the `output/blast_snippet_results` directory or by running
```
cat output/01_species_identification/blast_snippet_results/*blast.txt
```
to quickly inspect the blast results.

From cross referencing the accession number NC_002163.1 in field 2 at https://www.ncbi.nlm.nih.gov/nucleotide/ I was able to conclude that my genome is likely **Campylobacter jejuni subsp. jejuni NCTC 11168**.

**3. Optional - Double check result**

It would still be time consuming to BLAST the full genome so I decided to break it down into manageable chunks and this also means it can now be run in parallel. The species identification script aims to:

1. Split the genome into 50000bp chunks.
2. Run blast on these chunks in parallel on my local BLAST database.
3. Save output and log files in `logs` and `output` directories.

Execute BLAST on genome chunks by running:
```
./scripts/01_species_identification.sh
```

Check how many different target genomes the BLAST search identified:
```
cat ./output/01_species_identification/blast_results.txt | awk '{print $2}'sort |uniq
```

This confirms that the genome is accession NC_002163.1.

## Q2. Repeat Analysis

1. What is the longest size of the repeat in `genome.fa`?
2. How many repeats exist in this genome with lengths between 6000 and 7000 base pairs?

**1. Execute repeats analysis script**

Execute the repeats analysis script:
```
./scripts/02_repeat_analysis.sh
```

This will:
1. Run minimap2 to map `genome.fa` against itself
2. Parse the output file to identify repeats and calculate their lenghts
3. Calculate the longest repeat
4. Count the number of repeats between 6 and 7kb in length.

**2. Retrieve results**

Results are located in `output/02_repeat_analysis` and contain the self mapping output, the repeats lengths and the final results identifying the longest repeat and the number of repeats between 6 and 7kb in `results.txt`


## Q3. Gene Location

Find the location (start and end positions) of the two genes, `gen1` and `gen2`, in the `genome.fa` file.

**1. Execute gene location script**

Execute the gene location analysis script:
```
./scripts/03_gene_location.sh
```

This will:
1. Create a BLAST database from the `genome.fa`
2. RUN BLAST for `gen1` and `gen2` against this database
3. Extract the start and end positions for both genes and save these in an output folder

**2. Retrieve results**

Results are located in `output/03_gene_location`  consisting of the BLAST results and the gene locations `gene_locations.txt`