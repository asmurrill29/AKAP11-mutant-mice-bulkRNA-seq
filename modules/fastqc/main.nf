#!/usr/bin/env nextflow

process FASTQC {
    label 'process_low'
    publishDir params.outdir, mode: 'copy', pattern:'*.html' //make sure pattern is globbed html so that only those files are produced
    conda 'envs/fastqc_env.yml'

    input:
    tuple val(accession), path(reads) 

    output:
    tuple val(accession), path('*.zip'), emit: zip
    tuple val(accession), path('*.html'), emit: html

    script:
    """
    fastqc $reads --threads $task.cpus
    """

}