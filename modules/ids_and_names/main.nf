#!/usr/bin/env nextflow

process IDS_AND_NAMES {
    label 'process_low'
    container 'ghcr.io/bf528/pandas:latest'
    publishDir params.outdir, mode: 'copy'
    
    input:
    path gtf

    output:
    path ("ids_and_names.txt")

    script:
    """
    ids_and_names.py -i $gtf -o 'ids_and_names.txt'
    """
    

}