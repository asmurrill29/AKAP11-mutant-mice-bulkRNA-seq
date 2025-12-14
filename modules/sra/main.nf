#!/usr/bin/env nextflow

process GET_SRA_DATA {
    label 'process_high' //requires more threads for this process
    container 'quay.io/biocontainers/sra-tools:3.1.1--h4304569_0'
    publishDir "$projectDir/results/sra_downloads", mode:'copy' //send fastq files to particular directory to then be renamed
    
    input:
    val(sra_accession) //variable for accession number

    output:  
    tuple val(sra_accession), path("${sra_accession}*.fastq.gz")  //changed to tuple given issues downstream in creating paired FASTQC files

    script:
    //Dump fastq files with splitting
    //Compress the output files using pigz: utilizes multiple CPU cores and threads for compression
    """
    fasterq-dump ${sra_accession} \
     --split-files \
     --threads ${task.cpus} \
     --progress
    gzip ${sra_accession}*.fastq
    """
}

