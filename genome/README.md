# Genome Analysis

You are given an unknown genome of a real organism `genome.fa` and two genes: `gen1.fa` and `gen2.fa`



## Q1. Species Identification

Identify the species to which the given genome belongs.

**1. Navigate to starting directory and prerequisites**

1. Assuming you are starting from parent directory QIB_TECH_ASSESSMENT, navigate to `genome` subdirectory

2. This solution assumes that you have a local BLAST database. For this example I used the ref_prok_rep_genomes database but feel free to modify the script for a remote alignment or use an alternative database, to edit the database directory please refer to `config/01_config.sh` and edit the `$BLAST_DB_DIR ` environment variable path.

3. Finally this solution also assumes that you have singularity installed on your system and that you have compiled singularity container `genome_singularity.sif` by executing:

```
sudo singularity build ./scripts/genome_singularity.sif ./scripts genome_singularity.def
```

These prerequisites are also assumed for Q2 and Q3.

**2.  **


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
2. Parse the output file to identidy repeats and calculate their lenghts
3. Calculate the longest repeat
4. Count the number of repeats between 6 and 7kb in length.

**2. Retrieve results**

Results are located in `output/02_repeat_analysis` and contain the self mapping output, the repeats lengths and the final results identifying the longest repeat and the number of repeats between 6 and 7kb in `results.txt`


## Q3. Gene Location

Find the location (start and end positions) of the two genes, `gen1` and `gen2`, in the `genome.fa` file.

**1. Execute rgene location script**

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