#!/usr/bin/env nextflow

process MULTIQC {
    label 'process_low'
    container 'ghcr.io/bf528/multiqc:latest'
    publishDir params.outdir, mode: "copy"

    input:
    path '*'

    output:
    path "multiqc_report.html", emit: html
    path "multiqc_data"

    script:
    """
    multiqc .
    """
}