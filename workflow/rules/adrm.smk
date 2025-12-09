###############################
### Step 2: Remove Adapters ###
###############################

#This rule removes adapters from demultiplexed, single-end fastq reads
rule adapter_removal_SE:
    input: 
    	path = lambda wildcards: PATHS[wildcards.library]
    output:
        trimmed = "results/adrm/{library}_SE.collapsed.gz",
        discarded = "results/adrm/{library}_SE.discarded.gz",
        settings = "results/adrm/{library}_SE.settings"
    wildcard_constraints:
        library="|".join(SE_LIBS)
    conda:
        "../envs/adapter_removal.yaml"
    shell:
        "workflow/scripts/adapter_removal_SE.sh {input.path} {wildcards.library}"

#This rule removes adapters from demultiplexed, paired-end fastq reads
rule adapter_removal_PE:
    input: 
    	path = lambda wildcards: PATHS[wildcards.library]
    output:
        pair1 = "results/adrm/{library}_PE.pair1.truncated.gz",
        pair2 = "results/adrm/{library}_PE.pair2.truncated.gz",
        single = "results/adrm/{library}_PE.singleton.truncated.gz",
        collapse = "results/adrm/{library}_PE.collapsed.gz",
        collapse_trunc = "results/adrm/{library}_PE.collapsed.truncated.gz",
        disc = "results/adrm/{library}_PE.discarded.gz",
        set = "results/adrm/{library}_PE.settings"
    wildcard_constraints:
        library="|".join(PE_LIBS)
    conda:
        "../envs/adapter_removal.yaml"
    shell:
        "workflow/scripts/adapter_removal_PE.sh {input.path} {wildcards.library}"
