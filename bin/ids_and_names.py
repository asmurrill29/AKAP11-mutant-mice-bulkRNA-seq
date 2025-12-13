#!/usr/bin/env python

#import packages
import pandas as pd
from gtfparse import read_gtf
import argparse

#Argparse:

#generate variable for arpargse with description of script
parser = argparse.ArgumentParser(description='creates a delimited file containing the ensembl human ID and its corresponding gene name')

#designates gtf file as input
parser.add_argument('-i', dest='input', help='gtf file', required=True)

#designates text file with ouptut
parser.add_argument('-o', dest='output', help='text file', required=True)

#create variable for arguments for input and output methods
args = parser.parse_args()

#GTF Parse:

#define gtf file as dataframe
gtf_df = read_gtf(args.input)

#create new dataframe for gene rows (Polars syntax)
gene_df = gtf_df.filter(gtf_df["feature"] == "gene")

#extract gene IDs and gene names 
ids_df = gene_df.select(["gene_id", "gene_name"])

# Write to CSV file (Polars syntax)
ids_df.write_csv(args.output)