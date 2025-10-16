#!/usr/bin/env nextflow

process GET_GENOME {
    label 'process_low' //does not require many threads for this process
    publishDir params.outdir, mode:'copy' 
    container 'ubuntu:latest' //wget container


    output:
    path "${params.gencode_species}.${params.gencode_version}.primary_assembly.genome.fa.gz" //fasta files

    script:
    """
    wget -O ${params.gencode_species}.${params.gencode_version}.primary_assembly.genome.fa.gz ${params.gencode_ref_url}
    """  
}
