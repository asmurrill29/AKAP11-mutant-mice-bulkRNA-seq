#!/usr/bin/env python3

import argparse
import re


def parse_gtf(attr_string):
    """
    Parse the GTF attributes field and return a dictionary.
    """
    attributes = {}
    #split by semicolon and process each attribute
    for attr in attr_string.strip().rstrip(';').split(';'):
        attr = attr.strip()
        if attr:
            #define match pattern
            match = re.match(r'(\S+)\s+"?([^"]+)"?', attr)

            #add to the dictionary
            if match:
                key, value = match.groups()
                attributes[key] = value.strip('"')
    return attributes


def extract_gene_info(gtf_file, output_file):
    """
    Extract gene IDs and gene names from GTF file.
    """
    #generate dict
    genes = {}  
    
    #loop through the gtf and delineate fields
    with open(gtf_file, 'r') as f:
        for line in f:
            #skip comments
            if line.startswith('#'):
                continue
            
            fields = line.strip().split('\t')
            
            #GTF has 9 columns
            if len(fields) < 9:
                continue
            
            feature_type = fields[2]
            attributes = fields[8]
            
            #only process gene features
            if feature_type == 'gene':
                attr_dict = parse_gtf(attributes)
                
                #extract gene_id and gene_name
                gene_id = attr_dict.get('gene_id', '')
                gene_name = attr_dict.get('gene_name', gene_id)  #use gene_id if no gene_name
                
                if gene_id:
                    genes[gene_id] = gene_name
    
    #write to output file
    with open(output_file, 'w') as out:
        out.write("gene_id\tgene_name\n")  #header
        for gene_id, gene_name in sorted(genes.items()):
            out.write(f"{gene_id}\t{gene_name}\n")


def main():
    parser = argparse.ArgumentParser(
        description='Extract gene IDs and gene names from a GTF file'
    )
    
    parser.add_argument(
        '-i', '--input',
        required=True,
        help='Input GTF file'
    )
    
    parser.add_argument(
        '-o', '--output',
        required=True,
        help='Output text file with gene IDs and names'
    )
    
    args = parser.parse_args()
    
    extract_gene_info(args.input, args.output)


if __name__ == '__main__':
    main()