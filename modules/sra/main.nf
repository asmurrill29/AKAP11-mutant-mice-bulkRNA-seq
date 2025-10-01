#!/usr/bin/env nextflow

process GET_SRA_DATA {
    label 'process_high' //requires more threads for this process
    publishDir params.outdir, mode:'copy' //send fastq files to "results"
    conda 'envs/sratoolkit_env.yml' //path to valid yml file

    input:
    val(sra_accession) //variable for accession number

    output:  
    path ("${sra_accession}*.fastq.gz") //glob allows for both single and paired-end reads

    script:
    //Dump fastq files with splitting
    //Compress the output files using pigz: utilizes multiple CPU cores and threads for compression
    """
    fasterq-dump ${sra_accession} \
     --split-files \
     --threads ${task.cpus} \
     --progress
    pigz -p ${task.cpus} ${sra_accession}*.fastq
    """
}

