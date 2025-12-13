#!/usr/bin/env nextflow

process STAR_INDEX {
    label 'process_high'
    container 'ghcr.io/bf528/star:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    path gtf
    path genome

    output:
    path "star_index", emit: index


    script:
    //make an index directory in results
    //include amount of threads required
    //specify the run mode
    //specify the output directory for the index
    //include the genome and gtf files for indexing
    """
    mkdir star_index
    STAR --runThreadN $task.cpus \
        --runMode genomeGenerate \
        --genomeDir star_index \
        --genomeFastaFiles $genome \
        --sjdbGTFfile $gtf
    """
}