#!/usr/bin/env nextflow

process IDS_AND_NAMES {
    label 'process_low'
    container 'quay.io/biocontainers/gtfparse:2.3.0--pyh7cba7a3_0' //from biocontainers
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