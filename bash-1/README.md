# Task 1 : Metadata generation

## Objective
Generate an upload table in CSV format from paired-end read files for a read storage platform. Output format in a .csv file with the following fields:

* sampleName - The name of the sample (e.g., sample1)
* ProjectID - The ID of the project where all samples belong (use “83” in your example)
* FileForward - The path to the forward read file (e.g., path/to/sample1_R1.fastq)
* FileReverse - The path to the reverse read file (e.g., path/to/sample1_R2.fastq)

## Directory Structure
- `001.csv_question/`: Contains input paired-end read files.
- `scripts/`: Contains the script to generate the upload table.
- `output/`: Contains the generated CSV file.
- `logs/`: Contains log files for the process.