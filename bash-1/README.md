# Task 1 : Metadata generation

## Objective
Generate an upload table in CSV format from paired-end read files for a read storage platform. Output format in a .csv file with the following fields:

* sampleName - The name of the sample (e.g., sample1)
* ProjectID - The ID of the project where all samples belong (use “83” in your example)
* FileForward - The path to the forward read file (e.g., path/to/sample1_R1.fastq)
* FileReverse - The path to the reverse read file (e.g., path/to/sample1_R2.fastq)

## Directory Structure
- `config/` : Contains config file where inputs can be changed (e.g. Project ID)
- `scripts/`: Contains the script to generate the upload table.
- `output/`: Contains the generated CSV file.
- `logs/`: Contains log files for the process.

## Instructions to reproduce upload table

**1. Navigate to starting directory**
Assuming you are starting from parent directory QIB_TECH_ASSESSMENT, navigate to ```bash-1``` subdirectory

 ```
 cd bash-1
 ```

**2. Extract fastq files**

```
tar -xvzf 001.csv.question.txz
```

**3. From here you can execute scripts within scripts/ directory**

```
scripts/rename_reads.sh
scripts/generate_upload_table.sh
```

**4. After each step, check corresponding log files in log/ subdirectory**

**5. Output .csv file is located in outputs/ subdirectory**