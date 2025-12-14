#!/usr/bin/env python

#import packages
import pandas as pd
import argparse
import os

#Argparse:

#generate variable for arpargse with description of script
parser = argparse.ArgumentParser(description='concatenates all of the verse output files')

#designates gtf file as input
parser.add_argument('-i', dest='input', nargs='+', help='verse files', required=True)

#designates text file with ouptut
parser.add_argument('-o', dest='output', help='csv', required=True)

#create variable for arguments for input and output methods
args = parser.parse_args()

# Read all files and prepare them for concatenation
dfs = []

for file in args.input:
    # Read the current file
    df = pd.read_csv(file, sep='\t')
    
    # Extract sample name from filename
    sample_name = os.path.basename(file).replace('.exon.txt', '')
    
    # Rename the count column
    df = df.rename(columns={'count': sample_name})
    
    # Keep only gene and count columns
    df = df[['gene', sample_name]]
    
    # Set gene as index for proper alignment
    df = df.set_index('gene')
    
    # Add to list
    dfs.append(df)

# Concatenate all dataframes along columns (axis=1)
# This joins them side-by-side, aligning on the gene index
counts_matrix = pd.concat(dfs, axis=1)

# Reset index to make gene a column again
counts_matrix = counts_matrix.reset_index()

# Write the final counts matrix to CSV
counts_matrix.to_csv(args.output, index=False)