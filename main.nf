#!/usr/bin/env nextflow

include {GET_SRA_DATA} from './modules/sra'
include {FASTQC} from './modules/fastqc'
include {GET_GTF} from './modules/get_gtf'
include {GET_GENOME} from './modules/get_genome' 

workflow {

// Go through csv of accession values to create a channel
Channel.fromPath(params.accessions) 
| splitCsv(header:false)
| map { row -> row[1]}
| set {accessions}

//Download gtf file from GENCODE (Comprehensive gene annotation, primary)
GET_GTF() 

//Download reference genome from GENCODE (Genome sequence, primary assembly (GRCm39), primary)
GET_GENOME()

//Retrieve paired fastq files from accessions   
GET_SRA_DATA(accessions)

//Perform QC on the reads: acquire html and zip files describing results
FASTQC(GET_SRA_DATA.out)

}