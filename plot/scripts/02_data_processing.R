# Function to load libraries and install if not available
load_or_install <- function(package_name) {
  if (!require(package_name, character.only = TRUE)) {
    install.packages(package_name, dependencies = TRUE)
    library(package_name, character.only = TRUE)
  }
}

# Load necessary libraries
load_or_install("ggplot2")
load_or_install("dplyr")
load_or_install("tidyr")
load_or_install("gtools")
load_or_install("viridis")

# Set the working directory to the script's location
script_dir <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(script_dir)

# set and ensure output directory exists
output_dir <- "../output"
if (!dir.exists(output_dir)) {
  dir.create(output_dir)
}

# Function to strip prefixes (like d__, p__, etc.)
strip_prefix <- function(tax_label) {
  gsub("^.+__", "", tax_label)
}

# Function to find the highest available taxonomic level
find_highest_taxonomic_level <- function(df, levels) {
  for (level in levels) {
    if (all(!is.na(df[[level]]) & df[[level]] != "")) {
      return(level)
    }
  }
  return(NULL)
}

# Set file paths
metadata_file <- "../input/metadata.csv"
abundance_file <- "../input/table.csv"
taxonomy_file <- "../input/taxonomy.csv"

# Load the data
metadata <- read.csv(metadata_file)
abundance <- read.csv(abundance_file, row.names = 1)
taxonomy <- read.csv(taxonomy_file)

# Remove ASVs with at most 9 counts
abundance <- abundance[rowSums(abundance) > 9, ]

# Merge abundance and taxonomy data
abundance$ASV <- rownames(abundance)
taxonomy <- taxonomy %>%
  rename(ASV=X.TAXONOMY) %>%
  mutate(across(c(Domain, Phylum, Class, Order, Family, Genus, Species), strip_prefix))

abundance_taxonomy <- merge(abundance, taxonomy, by = "ASV")


# Find the highest available taxonomic level
taxonomic_levels <- c("Species", "Genus", "Family", "Order", "Class", "Phylum", "Domain")

highest_level <- find_highest_taxonomic_level(abundance_taxonomy, taxonomic_levels)
if (is.null(highest_level)) {
  stop("No common taxonomic level found without missing values.")
}

cat("Highest available taxonomic level for grouping: ", highest_level, "\n")

# Function to create pie chart for a given sample
create_pie_chart <- function(sample_name, data, level) {
  sample_data <- data %>%
    select(ASV, sample_name, all_of(level)) %>%
    rename(Count = sample_name, Taxonomy = all_of(level))
  
  sample_data <- sample_data %>%
    group_by(Taxonomy) %>%
    summarise(Count = sum(Count)) %>%
    mutate(Percentage = Count / sum(Count) * 100)
  
  ggplot(sample_data, aes(x = "", y = Percentage, fill = Taxonomy)) +
    geom_bar(stat = "identity", width = 1) +
    coord_polar(theta = "y") +
    theme_void() +
    labs(title = paste("Taxonomic Composition of Sample:", sample_name),
         subtitle = paste("Grouped by", level),
         fill = level)
}

# Define taxonomic level desired for pie chart
taxonomic_level <- "Class" # Define as highest_level if most complexity desired

# Prepare data for pie chart of "Mock"
mock_pie_chart_data <- abundance_taxonomy %>%
  select(ASV, Mock, all_of(taxonomic_level)) %>%
  rename(Count = Mock, Taxonomy = all_of(taxonomic_level)) %>%
  group_by(Taxonomy) %>%
  summarise(Count = sum(Count)) %>%
  mutate(Percentage = Count / sum(Count) * 100)

# Create and save pie chart for sample "Mock"
mock_pie_chart <- create_pie_chart("Mock", abundance_taxonomy, taxonomic_level)
filename <- file.path(output_dir, paste0("Mock_Pie_Chart_", taxonomic_level, ".png"))
ggsave(filename, plot = mock_pie_chart)



# Remove sample "Mock" and prepare data for stacked bar chart
abundance_taxonomy_long <- abundance_taxonomy %>%
  select(-Mock) %>%
  gather(Sample, Count, -ASV, -Domain, -Phylum, -Class, -Order, -Family, -Genus, -Species)

# Convert Sample to factor with correct order
abundance_taxonomy_long$Sample <- factor(abundance_taxonomy_long$Sample, 
                                         levels = mixedsort(unique(abundance_taxonomy_long$Sample)))

# Summarise the data by chosen taxonomic level
summarised_data <- abundance_taxonomy_long %>%
  group_by(Sample, !!sym(taxonomic_level)) %>%
  summarise(Total_Count = sum(Count)) %>%
  ungroup() %>%
  rename(Taxonomy = !!sym(taxonomic_level))

# Create stacked bar chart
stacked_bar_chart <- ggplot(summarised_data, aes(x = Sample, y = Total_Count, fill = Taxonomy)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  labs(title = "Taxonomic Composition of Samples",
       subtitle = paste("Grouped by", taxonomic_level),
       x = "Sample", y = "Total Count", fill = taxonomic_level) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

