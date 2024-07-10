# Task: Metadata generation

You are provided with a set of paired-end read files from a high-throughput sequencing project (see the file in this directory). 
Each sample consists of two files, one for the forward reads (ending in something like `_R1.fastq.gz`) and one for the reverse reads (ending in
`_R2.fastq.gz` or similar). 

You want to generate an upload table in CSV format for a read storage platform, which requires specific metadata fields for
each sample:

* sampleName - The name of the sample (e.g., sample1)
* ProjectID - The ID of the project where all samples belong (use “83” in your example)
* FileForward - The path to the forward read file (e.g., path/to/sample1_R1.fastq)
* FileReverse - The path to the reverse read file (e.g., path/to/sample1_R2.fastq)

Therefore your task is to write a bash script to generate the upload table in CSV format from all read files in the directory `001.irida_question/`.

If and only if you cannot write a bash script, you can use any other scripting language of your choice, but remember
that our preference is for a bash script or command.

If you cannot access the directory, please write a generic script and let us know the reason why you could not access it.
