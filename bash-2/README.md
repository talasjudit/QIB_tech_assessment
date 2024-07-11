# IQ-tree

**1. Navigate to starting directory**

Assuming you are starting from parent directory QIB_TECH_ASSESSMENT, navigate to ```bash-2``` subdirectory

**2. Download singularity and compile container**

Make sure singularity is downloaded on your system and compile the singularity definition file:
```
sudo singularity build ./scripts/iqtree_singularity.sif ./scripts/iqtree_singularity.def
```

**3. Extract necessary files**

```
tar -xvf 002.iqtree_question.txz
```

**4. Run IQ-tree in the background**

```
./scripts/run_iqtree.sh
```

**5. Retrieve results**

Check results:
- `output/` : contains output files
- `logs/` : contains stdout and stderr log files