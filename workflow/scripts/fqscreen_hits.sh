#!/bin/bash
INPUT=$1
OUTPUT=$2
awk 'NF && NR > 2 && $1 !~ /^%Hit/ {
    mapped = $5 + $7 + $9 + $11
    genomes[$1] = mapped
    total += mapped
}
END {
    for (g in genomes) {
        pct = (total > 0) ? (genomes[g] / total * 100) : 0
        printf "%s\t%d\t%.2f%%\n", g, genomes[g], pct
    }
}' ${INPUT} | sort -k2,2nr > ${OUTPUT}
