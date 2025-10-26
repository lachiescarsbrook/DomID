#!/bin/bash
READS=$1
REF=$2
SAI=$3
BAM=$4
SORT=$5
SEED=$6
THREADS=$7

#Maps reads to the CanFam3.1 reference genome (GCF_000002285.3) with a Y chromosome
bwa aln -l $SEED -t $THREADS $REF $READS > $SAI
bwa samse $REF $SAI $READS | samtools view -Shu - > $BAM
#Sorts mapped reads based on chromosome/position IDs
samtools sort -O bam -o $SORT $BAM
