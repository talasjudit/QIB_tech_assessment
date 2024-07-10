# IQ-tree

You are provided with a set of alignments in fasta format, 
each alignment is a multiple sequence alignment (MSA) of a
gene with file name ending in ".aln". 

You want to run a program called iqtree2 on each alignment file and store
the generated tree into a file with same name as the alignment file but with ".treefile" extension. 

This can be accomplished with option "--prefix <prefix>" where <prefix> is the name of the alignment file without the ".aln". For
example, for a file named "gene1.aln", the command you want to run is:

```
iqtree2 -s gene1.aln --prefix gene1 -m HKY+G
```

Your task is to write a shell script or command that will take all alignment files in directory `002.iqtree_question` and run
iqtree2 as above on each, preferentially in parallel, with stdio/stderr redirection, and running even after the terminal
session is closed.
The objective is for us to see the script or command, and not the tree files. If you cannot access the directory please
explain why, and write a general script that works with all alignment files ending in ".aln" in the current directory.
