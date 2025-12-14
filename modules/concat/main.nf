#!/usr/bin/env nextflow

process CONCAT {
    label 'process_low'
    container 'ghcr.io/bf528/pandas:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    path verse_files

    output:
    path("counts_matrix.csv")

    script:
    """
    concat.py -i $verse_files -o counts_matrix.csv
    """

}