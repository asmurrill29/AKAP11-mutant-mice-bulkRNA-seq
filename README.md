## Analyzing bulkRNA-sequencing data in the prefrontal cortex of Akap11 mutant mice
A project seeking to reproduce, compare, and analyze the results found in Song et al. (2025), "Elevated synaptic PKA activity and abnormal striatal dopamine signaling in Akap11 mutant mice, a genetic model of schizophrenia and bipolar disorder" (doi: https://doi.org/10.1101/2024.09.24.614783). This is a working bulk RNA-seq pipeline and pathway enrichment analysis for the 12 week prefrontal cortex group across three genotypes, Akap11 (-/-, KO), Akap11 (+/-, HET), and Akap11 (+/+, WT). 

### Data Acquisition
The raw bulk RNA-seq reads were found on Gene Expression Omnibus (GEO) with the ID number GSE306677 as listed in the publication. The samples' SRA accession numbers were selected from this database for this project. 

### Workflow and Analysis 
Notes:
Pre-processing and quality control were performed using Nextflow (v25.04.6).

Singularity container images: pipeline_containers repository (BF528, n.d.) and BioContainers (da Veiga Leprevost et al., 2017).

Only the extracted prefrontal cortices (PFC) of 12 week-old mice were analyzed in this project, but other samples can be used for this pipeline (i.e. 4wk-Str).

Create CSV samplesheet as a param.

    1. Extract files using sra-tools(v3.1.1): --split-files parameter.
    2. Rename by sample name using an argparse-based python script (pandas v2.2.3)
    3. Download the GTF annotation and reference genome files: wget command using 
       default parameters
    4. FASTQC (v0.12.1) on a channel of the paired reads using default parameters
    5. STAR (v2.7.11b) to index using default parameters and then align to generate
       unsorted BAM files and output logs: --outSAMtype BAM Unsorted and 2> ${name}.Log.final.out parameters
    6. MULTIQC process (v1.25) using align logs and FastQC logs, standard parameters
    7. VERSE (v0.1.5) to make counts matrix under default parameters
 
### Results
Check diff_expr_analysis/AKAP11_analysis.RMD and final_project.pdf for QC analysis and results.

### Folder Structure
bin/: argparse python scripts for intermediate work

diff_expr_analysis/: Rmd file for detailed DE analysis

envs/: yml files used before the switch to singularity

modules/: pipeline processes

main.nf: main workflow with included processes from modules

nextflow.config: variable storage and profile







