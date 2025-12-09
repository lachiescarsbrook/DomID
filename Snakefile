#!/usr/bin/env python

#Load config file
configfile: "config/user_config.yaml"

#Modules:
include: "workflow/rules/dict.smk"
include: "workflow/rules/adrm.smk"
include: "workflow/rules/concat.smk"
include: "workflow/rules/readQC.smk"
include: "workflow/rules/reads2geno.smk"
include: "workflow/rules/pca.smk"

rule all:
    input:
        "workflow/files/chromosomes.txt",
        expand("results/adrm/{library}_SE.collapsed.gz", library=SE_LIBS),
        expand("results/adrm/{library}_PE.collapsed.gz", library=PE_LIBS),
        expand("results/adrm/{sample}_adrm.fq.gz", sample = SAMPLES.keys()),
        expand("results/plots/{run}_mtDNA_QC.txt", run = config["run"]),
        expand("results/stats/{run}_all_stats.txt", run = config["run"]),
        expand("results/plots/{run}_PCA_plot.pdf", run = config["run"]),
        expand("results/plots/{run}_sexID_plot.pdf", run = config["run"]),
        expand("results/plots/{run}_posteriors.txt", run = config["run"])
