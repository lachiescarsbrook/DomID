#################################
### Step 4: Ensure Off-Target ### 
###   Species are Excluded    ###
#################################

#This rule creates a configuration file for fastq_screen
rule fqscreen_config:
    input:
        adrm_reads = "results/adrm/{sample}_adrm.fq.gz"
    output:
        fqscreen = "results/fastqscreen/{sample}_fastq_screen.conf"
    conda:
        "../envs/readQC.yaml"
    shell:
        "workflow/scripts/fqscreen_config.sh {output.fqscreen}"

#This rule maps collapsed reads against mitochondrial reference sequences of common domestic and wild species
rule mtDNA_screen:
    input:
        fqscreen = "results/fastqscreen/{sample}_fastq_screen.conf",
        adrm_reads = "results/adrm/{sample}_adrm.fq.gz"
    output:
        out1 = "results/fastqscreen/{sample}_adrm_screen.png",
        out2 = "results/fastqscreen/{sample}_adrm_screen.html",
        out3 = "results/fastqscreen/{sample}_adrm_screen.txt"
    params:
        mapthreads=config["map_threads"]
    conda:
        "../envs/readQC.yaml"
    shell:
        "fastq_screen --subset 0 --threads {params.mapthreads} --conf {input.fqscreen} {input.adrm_reads} --outdir results/fastqscreen"

#This rule calculates the percentage of reads mapping to different taxa
rule mtDNA_percent:
    input:
        "results/fastqscreen/{sample}_adrm_screen.txt"
    output:
        "results/fastqscreen/{sample}_hits.txt"
    conda:
        "../envs/readQC.yaml"
    shell:
        "workflow/scripts/fqscreen_hits.sh {input} {output}"

#This rule calculates the percentage difference between reads mapping to canid and non-canid taxa
rule mtDNA_diff:
    input:
        expand("results/fastqscreen/{sample}_hits.txt", sample = SAMPLES)
    output:
        expand("results/plots/{run}_mtDNA_QC.txt", run = config["run"])
    params:
        species=config["SNP_panel"]
    conda:
        "../envs/readQC.yaml"
    shell:
        "workflow/scripts/fqscreen_diff.sh {input} {output} {params.species}"