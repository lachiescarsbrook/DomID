#!/bin/bash
OUTNAME=$1
#Find location of bwa for fastq_screen config file
BWA_PATH=`which bwa`
echo "BWA $BWA_PATH" > ${OUTNAME}
#Specify location of mitochondrial reference sequences
echo "DATABASE bear workflow/files/mtDNA_ref/bear.fasta" >> ${OUTNAME}
echo "DATABASE camel workflow/files/mtDNA_ref/camel.fasta" >> ${OUTNAME}
echo "DATABASE carp workflow/files/mtDNA_ref/carp.fasta" >> ${OUTNAME}
echo "DATABASE cat workflow/files/mtDNA_ref/cat.fasta" >> ${OUTNAME}
echo "DATABASE cattle workflow/files/mtDNA_ref/cattle.fasta" >> ${OUTNAME}
echo "DATABASE chicken workflow/files/mtDNA_ref/chicken.fasta" >> ${OUTNAME}
echo "DATABASE coyote workflow/files/mtDNA_ref/coyote.fasta" >> ${OUTNAME}
echo "DATABASE deer workflow/files/mtDNA_ref/deer.fasta" >> ${OUTNAME}
echo "DATABASE dhole workflow/files/mtDNA_ref/dhole.fasta" >> ${OUTNAME}
echo "DATABASE dog workflow/files/mtDNA_ref/dog.fasta" >> ${OUTNAME}
echo "DATABASE duck workflow/files/mtDNA_ref/duck.fasta" >> ${OUTNAME}
echo "DATABASE ferret workflow/files/mtDNA_ref/ferret.fasta" >> ${OUTNAME}
echo "DATABASE fox workflow/files/mtDNA_ref/fox.fasta" >> ${OUTNAME}
echo "DATABASE goat workflow/files/mtDNA_ref/goat.fasta" >> ${OUTNAME}
echo "DATABASE horse workflow/files/mtDNA_ref/horse.fasta" >> ${OUTNAME}
echo "DATABASE human workflow/files/mtDNA_ref/human.fasta" >> ${OUTNAME}
echo "DATABASE mouse workflow/files/mtDNA_ref/mouse.fasta" >> ${OUTNAME}
echo "DATABASE pigeon workflow/files/mtDNA_ref/pigeon.fasta" >> ${OUTNAME}
echo "DATABASE pig workflow/files/mtDNA_ref/pig.fasta" >> ${OUTNAME}
echo "DATABASE rabbit workflow/files/mtDNA_ref/rabbit.fasta" >> ${OUTNAME}
echo "DATABASE rat workflow/files/mtDNA_ref/rat.fasta" >> ${OUTNAME}
echo "DATABASE salmon workflow/files/mtDNA_ref/salmon.fasta" >> ${OUTNAME}
echo "DATABASE sheep workflow/files/mtDNA_ref/sheep.fasta" >> ${OUTNAME}
echo "DATABASE wolf workflow/files/mtDNA_ref/wolf.fasta" >> ${OUTNAME}