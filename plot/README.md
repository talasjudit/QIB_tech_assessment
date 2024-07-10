# Plot

Using R (preferred) or Python (with Matplotlib and/or Seaborn) generate a plot of the taxonomic composition of the samples of a metabarcoding experiment.

## Input files

A **Metadata** table containing a label for each sample. 
Available from: https://raw.githubusercontent.com/quadram-institute-bioscience/datasciencegroup/main/2_rarefaction/metadata.csv


An **Abundance table** (also called *feature table*), having the samples as columns and a set of detected marker variants (amplicon sequence variants, ASV) in each sample. This is a raw table without any normalisation.

Available from: https://raw.githubusercontent.com/quadram-institute-bioscience/datasciencegroup/main/2_rarefaction/table.csv


A **Taxonomy table**, associating to each ASV a taxonomy.

Available from: https://raw.githubusercontent.com/quadram-institute-bioscience/datasciencegroup/main/2_rarefaction/taxonomy.csv

## Task

1. Remove all the ASVs having at most 9 counts
2. Make a pie chart of the composition of the sample “Mock”
3. Remove the sample “Mock” from the dataframe, and make a stacked bar chart of the composition of the other sample, collapsing the counts having identical taxonomy (i.e. plot the abundance of the detected taxonomies rather than ASVs)