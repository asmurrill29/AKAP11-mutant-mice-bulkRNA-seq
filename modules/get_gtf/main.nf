#!/usr/bin/env nextflow

process GET_GTF {
    label 'process_low' //does not require many threads for this process
    container 'quay.io/biocontainers/python:3.11'
    publishDir params.outdir, mode:'copy' 
    


    output:

    path "${params.gencode_species}.${params.gencode_version}.primary_assembly.annotation.gtf"

    script:
    //downloads gtf annotation file, unzips
    """
    wget -O ${params.gencode_species}.${params.gencode_version}.primary_assembly.annotation.gtf.gz ${params.gencode_gtf_url}
    gunzip *.gz
    """  
}


