#!/usr/bin/env python

#import packages
import argparse
import csv
import shutil
from pathlib import Path
import re


#Renaming:

##helper functions

def load_mapping(csv_file):
    """Generate dictionary for sra to sample name"""
    #initialize dictionary
    mapping = {}

    #create reader variable and loop through the rows making the dictionary
    with open(csv_file, 'r') as file:
        reader = csv.reader(file)
        for row in reader:
            sra_acc = row[1].strip()
            sample_name = row[2].strip()
            mapping[sra_acc] = sample_name
    return mapping
        
def renaming(input_dir, output_dir, mapping, move = False):
    """Uses argparse parameters to rename each sample with its correct name
    Args reference:
        input_dir: directory containing SRA-named files
        output_dir: directory for renamed files
        mapping: dictionary mapping SRA IDs to sample names
        move: if True, move files instead of copying
    """
    #designate paths using Pathlib for input and output arguments
    input_path = Path(input_dir)
    output_path = Path(output_dir)

    #manage boolean parameters for making output directory: generate parent directories and ignore if parent directory already exists
    output_path.mkdir(parents = True, exist_ok = True)

    #use regular expressions to find SRA number within read name and match to csv
    sra_pattern = re.compile(r'^(SRR\d+)(.*)$')

    #initiate list of files
    files_to_rename = []

    #iterate over contents of directory to find matches
    for file in input_path.iterdir():
        match = sra_pattern.match(file.name)
        if not match:
            continue

        sra_id = match.group(1) #grouped by sra number
        suffix = match.group(2) #grouped by _1.fastq.gz, etc.

        #refer back to mapping dictionary to generate the new name and path
        if sra_id in mapping:
            sample_name = mapping[sra_id]
            new_name = f"{sample_name}{suffix}"
            files_to_rename.append((file, new_name))
       
    #perform the renaming
    for old_file, new_file in files_to_rename:
        new_path = output_path/new_file

        #same directory - just rename
        if input_path == output_path:
            
            old_file.rename(new_path)

        #different directories - copy or move
        else:
             #use shutil pacakge to either move old sra+suffix file into new directory or copy them
            if move:
                shutil.move(str(old_file), str(new_path))
            else:
                shutil.copy2(str(old_file), str(new_path))
    

#finally, employ helper functions to rename the files
def main():
    #Argparse:

    #generate variable for arpargse with description of script
    parser = argparse.ArgumentParser(description='uses prior csv with sample names and succession to rename reads with sample names')

    #designates sra accessions as input
    parser.add_argument('-i', dest='input', help='directory with sra accessions', required=True)

    #designates directory with renamed files as output
    parser.add_argument('-o', dest='output', help='directory with renamed files', required=True)

    #designates csv file as mapping intermediate
    parser.add_argument('-m', dest='mapping', help='text file', required=True)

    parser.add_argument('--move', action = 'store_true', help='move files rather than copy (deletes originals)')

    #create variable for arguments for input and output methods
    args = parser.parse_args()

    #obtain mapping from load_mapping
    mapping = load_mapping(args.mapping)

    #rename!
    renaming(args.input, args.output, mapping, move=args.move)

if __name__ == '__main__':
    main()