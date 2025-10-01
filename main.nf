#!/usr/bin/env nextflow

include {GET_SRA_DATA} from './modules/sra'
include {FASTQC} from './modules/fastqc'

workflow {

// Go through csv of accession values to create a channel
Channel.fromPath(params.accessions) 
| splitCsv(header:false)
| map { row -> row[1]}
| set {accessions}

//Retrieve paired fastq files from accessions   
GET_SRA_DATA(accessions)

//Perform QC on the reads: acquire html and zip files describing results
FASTQC(GET_SRA_DATA.out)

}