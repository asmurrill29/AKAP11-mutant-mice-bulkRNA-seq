#!/usr/bin/env nextflow

//included processes from modules
include {GET_SRA_DATA} from './modules/sra'
include {RENAME_SAMPLES} from './modules/rename_samples'
include {GET_GTF} from './modules/get_gtf'
include {IDS_AND_NAMES} from './modules/ids_and_names'
include {GET_GENOME} from './modules/get_genome'
include {FASTQC} from './modules/fastqc'
include {STAR_INDEX} from './modules/star_index'
//include {STAR_ALIGN} from './modules/star_align'
//include {MULTIQC} from './modules/multiqc'
//include {VERSE} from './modules/verse'
//include {CONCAT} from './modules/concat'

workflow {

// Go through csv of accession values to create a channel
Channel.fromPath(params.accessions) 
| splitCsv(header:false)
| map { row -> row[1]}
| set {accessions}

//Retrieve paired fastq files from accessions   
GET_SRA_DATA(accessions)

//Generate a channel to rename the reads by sample name
mapping_csv_ch = Channel.fromPath(params.accessions)

//Extract just the files from the tuple for renaming
    unnamed_files= GET_SRA_DATA.out
        .map { sra_id, files -> files }
        .flatten()
        .collect()

//Rename files to be labeled by sample name, not accession number
RENAME_SAMPLES(unnamed_files, mapping_csv_ch)

//Download gtf file from GENCODE (Comprehensive gene annotation, primary)
GET_GTF() 

//Select gene IDs and gene names for downstream differential expression analysis
IDS_AND_NAMES(GET_GTF.out) 

//Download reference genome from GENCODE (Genome sequence, primary assembly (GRCm39), primary)
GET_GENOME()

//Perform QC on the reads: acquire html and zip files describing results

//Convert to tuples for FASTQC
renamed_tuples = RENAME_SAMPLES.out.renamed_reads
    .flatten()
    .map { file ->
        def sample_name = file.name.replaceAll(/(_[12])\.fastq\.gz$/, '')
        return tuple(sample_name, file)
    }
    .groupTuple()

FASTQC(renamed_tuples)

//Index the reference genome using the gtf annotation file
STAR_INDEX(GET_GTF.out, GET_GENOME.out) 

//Align reads retrieved from SRA accessions to genome using the generated index
//STAR_ALIGN(RENAME_SAMPLES.out.renamed_reads, STAR_INDEX.out.index) 

}