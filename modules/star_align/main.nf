#!/usr/bin/env nextflow

process STAR_ALIGN {
    label 'process_high'
    container 'ghcr.io/bf528/star:latest' 
    publishDir params.outdir, mode: 'copy'

    input:
    tuple val(name), path(reads)
    path star_index
    
    output:
    tuple val(name), path("${name}.Aligned.out.bam"), emit: bam
    path "${name}.Log.final.out", emit: log

    script:
    """
    STAR --runThreadN $task.cpus \
    --genomeDir $star_index \
    --readFilesIn ${reads[0]} ${reads[1]} \
    --readFilesCommand zcat \
     --outFileNamePrefix ${name}. \
     --outSAMtype BAM Unsorted\
     2> ${name}.Log.final.out
    """











}