#!/usr/bin/env nextflow

process RENAME_SAMPLES {
    label 'process_low'
    container 'ghcr.io/bf528/pandas:latest'
    publishDir params.outdir, mode:'copy' 

    input:
    path reads
    path mapping_csv_ch

    output:
    path("renamed/*.fastq.gz"), emit: renamed_reads


    script:
    """
    mkdir -p renamed
    rename_samples.py -i . -o renamed -m $mapping_csv_ch
    """

}