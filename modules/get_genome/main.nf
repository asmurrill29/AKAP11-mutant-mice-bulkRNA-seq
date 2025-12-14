#!/usr/bin/env nextflow

process GET_GENOME {
    label 'process_low' //does not require many threads for this process
    container 'quay.io/biocontainers/python:3.11'
    publishDir params.outdir, mode:'copy' 
    


    output:
    path "${params.gencode_species}.${params.gencode_version}.primary_assembly.genome.fa" //fasta files

    script:
    //downloads reference genome, unzips
    """
    wget -O ${params.gencode_species}.${params.gencode_version}.primary_assembly.genome.fa.gz ${params.gencode_ref_url}
    gunzip *.gz 
    """  
}
