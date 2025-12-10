#!/bin/bash
OUTNAME=$1
#Find location of bwa for fastq_screen config file
BWA_PATH=`which bwa`
echo "BWA $BWA_PATH" > ${OUTNAME}
#Specify location of mitochondrial reference sequences
echo "DATABASE Alpaca workflow/files/mtDNA_ref/Alpaca.fasta" >> ${OUTNAME}
echo "DATABASE Bear workflow/files/mtDNA_ref/Bear.fasta" >> ${OUTNAME}
echo "DATABASE Bison workflow/files/mtDNA_ref/Bison.fasta" >> ${OUTNAME}
echo "DATABASE Buffalo workflow/files/mtDNA_ref/Buffalo.fasta" >> ${OUTNAME}
echo "DATABASE Camel workflow/files/mtDNA_ref/Camel.fasta" >> ${OUTNAME}
echo "DATABASE Carp workflow/files/mtDNA_ref/Carp.fasta" >> ${OUTNAME}
echo "DATABASE Cat workflow/files/mtDNA_ref/Cat.fasta" >> ${OUTNAME}
echo "DATABASE Cattle workflow/files/mtDNA_ref/Cattle.fasta" >> ${OUTNAME}
echo "DATABASE Chicken workflow/files/mtDNA_ref/Chicken.fasta" >> ${OUTNAME}
echo "DATABASE Coyote workflow/files/mtDNA_ref/Coyote.fasta" >> ${OUTNAME}
echo "DATABASE Deer workflow/files/mtDNA_ref/Deer.fasta" >> ${OUTNAME}
echo "DATABASE Dhole workflow/files/mtDNA_ref/Dhole.fasta" >> ${OUTNAME}
echo "DATABASE Dog workflow/files/mtDNA_ref/Dog.fasta" >> ${OUTNAME}
echo "DATABASE Donkey workflow/files/mtDNA_ref/Donkey.fasta" >> ${OUTNAME}
echo "DATABASE Duck workflow/files/mtDNA_ref/Duck.fasta" >> ${OUTNAME}
echo "DATABASE Ferret workflow/files/mtDNA_ref/Ferret.fasta" >> ${OUTNAME}
echo "DATABASE Fox workflow/files/mtDNA_ref/Fox.fasta" >> ${OUTNAME}
echo "DATABASE Goat workflow/files/mtDNA_ref/Goat.fasta" >> ${OUTNAME}
echo "DATABASE Hare workflow/files/mtDNA_ref/Hare.fasta" >> ${OUTNAME}
echo "DATABASE Horse workflow/files/mtDNA_ref/Horse.fasta" >> ${OUTNAME}
echo "DATABASE Human workflow/files/mtDNA_ref/Human.fasta" >> ${OUTNAME}
echo "DATABASE LeopardCat workflow/files/mtDNA_ref/LeopardCat.fasta" >> ${OUTNAME}
echo "DATABASE Llama workflow/files/mtDNA_ref/Llama.fasta" >> ${OUTNAME}
echo "DATABASE Mouse workflow/files/mtDNA_ref/Mouse.fasta" >> ${OUTNAME}
echo "DATABASE Pig workflow/files/mtDNA_ref/Pig.fasta" >> ${OUTNAME}
echo "DATABASE Pigeon workflow/files/mtDNA_ref/Pigeon.fasta" >> ${OUTNAME}
echo "DATABASE Rabbit workflow/files/mtDNA_ref/Rabbit.fasta" >> ${OUTNAME}
echo "DATABASE Rat workflow/files/mtDNA_ref/Rat.fasta" >> ${OUTNAME}
echo "DATABASE Salmon workflow/files/mtDNA_ref/Salmon.fasta" >> ${OUTNAME}
echo "DATABASE Sheep workflow/files/mtDNA_ref/Sheep.fasta" >> ${OUTNAME}
echo "DATABASE Turkey workflow/files/mtDNA_ref/Turkey.fasta" >> ${OUTNAME}
echo "DATABASE Yak workflow/files/mtDNA_ref/Yak.fasta" >> ${OUTNAME}
