#!/usr/bin/env nextflow

process FASTQC {
    label 'process_low'
    container 'ghcr.io/bf528/fastqc:latest' 
    publishDir "${params.outdir}/fastqc", mode: 'copy'

    input:
    tuple val(sample_name), path(reads) 

    output:
    tuple val(sample_name), path('*.zip'), emit: zip
    //tuple val(sample_name), path('*.html'), emit: html

    script:
    """
    mkdir -p \$PWD/tmp_fastqc
    export TMPDIR=\$PWD/tmp_fastqc
    
    fastqc ${reads} --threads ${task.cpus}
    
    rm -rf \$PWD/tmp_fastqc
    """

}