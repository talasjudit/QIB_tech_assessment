# Plot

## Task

1. Remove all the ASVs having at most 9 counts
2. Make a pie chart of the composition of the sample “Mock”
3. Remove the sample “Mock” from the dataframe, and make a stacked bar chart of the composition of the other sample, collapsing the counts having identical taxonomy (i.e. plot the abundance of the detected taxonomies rather than ASVs)

## Prerequisites and recommendations

I recommend running this script interactively as I have included some options for plotting based on different taxonomical classifications but it can also be run as is, in which case the pie charts and stacked bar charts will output results based on the taxonomical grouping of class (This was chosen as a default as it offers a middle ground in terms of complexity whilst also being readable).

Whichever taxonomical grouping is chosen, this will be specified in the chart and the plot's name automatically to avoid confusion.

This workflow assumes you have R installed on your system.

**1. Navigate to starting directory**

Assuming you are starting from parent directory QIB_TECH_ASSESSMENT, navigate to `plot` subdirectory

**2. Retrieve necessary data**

Run `./scripts/01_get_data.sh` to retrieve necessary data, which will be saved in the `input` directory

**3. Run Rscript**

Run R script directly from the command line or RStudio
```
Rscript ./scripts/02_data_processing.R
```

This script will perform the steps listed above and then calculate the highest taxonomical grouping available that has no missing data. In this case this was order but the charts looked overwhelmed with this amount of information so I decided to go with class. 

However, with a quick change to the `taxonomic_level` object, the plots with other taxonomical classifications can be easily recreated. In fact I left these plots in the `output` folder as well.

**4. Retrieve results**

As menitoned the plots are located in the `output` directory in a pdf format.
