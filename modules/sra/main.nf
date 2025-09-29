#!/usr/bin/env nextflow

process GET_SRA_DATA {
    label 'process_high'
    publishDir params.outdir, mode:'copy'

    input:
    val(sra_accession)

    output: 
    path ("${sra_accession}.fastq.gz")

    script:
    """
    prefetch ${sra_accession}
    fasterq-dump --split-files ${sra_accession}
    gzip ${sra_accession}_1.fastq
    gzip ${sra_accession}_2.fastq 
    """
}

