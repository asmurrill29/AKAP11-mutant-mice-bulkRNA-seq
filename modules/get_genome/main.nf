#!/usr/bin/env nextflow

process GET_GENOME {
    label 'process_low' //does not require many threads for this process
    publishDir params.outdir, mode:'copy' 
    conda 'envs/download.yml' // wget download yml file


    output:
    path "${params.gencode_species}.${params.gencode_version}.primary_assembly.genome.fa" //fasta files

    script:
    //downloads reference genome, unzips
    """
    wget -O ${params.gencode_species}.${params.gencode_version}.primary_assembly.genome.fa.gz ${params.gencode_ref_url}
    gunzip *.gz 
    """  
}
