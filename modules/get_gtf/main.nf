#!/usr/bin/env nextflow

process GET_GTF {
    label 'process_low' //does not require many threads for this process
    publishDir params.outdir, mode:'copy' 
    conda 'envs/download.yml' // wget download yml file


    output:

    path "${params.gencode_species}.${params.gencode_version}.primary_assembly.annotation.gtf"

    script:
    //downloads gtf annotation file, unzips
    """
    wget -O ${params.gencode_species}.${params.gencode_version}.primary_assembly.annotation.gtf.gz ${params.gencode_gtf_url}
    gunzip *.gz
    """  
}


