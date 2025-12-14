#!/usr/bin/env nextflow

process VERSE {
    label 'process_high'
    container 'ghcr.io/bf528/verse:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    tuple val(name), path(bam)
    path gtf

    output:
    path "*.exon.txt"

    script:
    """
    verse -a $gtf -o ${name} $bam
    """
}