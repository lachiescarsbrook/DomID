#!/bin/bash
BAM=$1
PANEL=$2
SAMPLE=$3
MAPQ=$4
READQ=$5
TRIM=$6
#Calculates genotype likelihoods using SAMTOOLS, and performs haplotype calling for SNPs in the reference panel
./workflow/angsd/angsd -GL 1 -i $BAM -doMajorMinor 3 -sites $PANEL -doHaploCall 1 -doCounts 1 -minMapQ $MAPQ -minQ $READQ -trim $TRIM -out results/geno/$SAMPLE
#Converts ANGSD haplotypes to tped/tfam format 
./workflow/angsd/misc/haploToPlink results/geno/$SAMPLE.haplo.gz results/geno/$SAMPLE
