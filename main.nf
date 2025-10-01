#!/usr/bin/env nextflow

include {GET_SRA_DATA} from './modules/sra'

workflow {

// Go through csv of accession values to create a channel
Channel.fromPath(params.accessions) 
| splitCsv(header:false)
| map { row -> row[1]}
| set {accessions}
   
GET_SRA_DATA(accessions)

}