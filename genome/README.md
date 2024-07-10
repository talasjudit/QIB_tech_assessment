# Genome Analysis

You are given an unknown genome of a real organism `genome.fa` and two genes: `gen1.fa` and `gen2.fa`

## Q1. Species Identification

Identify the species to which the given genome belongs.

## Q2. Repeat Analysis

Repeats are sequences of DNA that occur in multiple copies throughout a genome. They can vary in length, frequency, and distribution. Repeats play important roles in genomic structure and function, including gene regulation, chromosome structure, and evolutionary processes.

1. What is the longest size of the repeat in `genome.fa`?
2. How many repeats exist in this genome with lengths between 6000 and 7000 base pairs?

Hint: Repeats can be identified by mapping the genome against itself with **minimap2** and parameters `-DP -k19 -w19 -m200`

## Q3. Gene Location

Find the location (start and end positions) of the two genes, `gen1` and `gen2`, in the `genome.fa` file.

The location is 1-based index.

The three questions are independent, you can answer as many as you can.

Expected results:

- The answer to each question
- Your evidence of the answer (code, software, methods used)