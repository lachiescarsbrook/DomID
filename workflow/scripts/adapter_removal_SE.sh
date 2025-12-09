#!/bin/bash
IN=$1
LIBRARY=$2
#Searches input directory for fastq files with the given sample ID
FILES=$(find "$IN" -type f \( -name "*.fastq*" -o -name "*.fq*" \) | grep -E "${LIBRARY}([_.-]|$)" | sort)
#Assigns variable to single-end reads
READ=$(echo "$FILES" | sed -n '1p')
#Removes adapters, low quality, and missing bases from single-end reads
AdapterRemoval --file1 "$READ" --trimns --trimqualities --gzip --qualitymax 60 --basename results/adrm/${LIBRARY}_SE
mv results/adrm/${LIBRARY}_SE.truncated.gz results/adrm/${LIBRARY}_SE.collapsed.gz