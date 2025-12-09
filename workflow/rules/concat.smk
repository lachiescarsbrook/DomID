###############################
### Step 3: Combine Reads   ### 
### from Multiple Libraries ###
###############################

#Combines collapsed reads from single/multiple libraries for a given sample
rule concat_reads:
    input:
        se = expand("results/adrm/{library}_SE.collapsed.gz", library=SE_LIBS),
        pe = expand("results/adrm/{library}_PE.collapsed.gz", library=PE_LIBS),
        file = config["files"]
    output:
        "results/adrm/{sample}_adrm.fq.gz"
    params:
        sample = lambda wildcards: wildcards.sample
    shell:
        "workflow/scripts/concatenate.sh {input.file} {params.sample}"
