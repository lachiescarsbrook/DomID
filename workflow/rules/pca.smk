################################
### Step 6: SmartPCA and LDA ###
################################

rule merge_list:
    input:
        expand("results/stats/{run}_all_stats.txt", run=[config["run"]])
    params:
        sample = list(SAMPLES.keys())
    output:
        expand("results/merge/{run}_merge.txt", run=[config["run"]])
    shell:
        "for sample in {params.sample}; do echo results/geno/$sample >> {output}; done"

#This rule merges haploid genotypes from unknown samples with the reference panel
rule vcf_combine:
    input:
        merge = expand("results/merge/{run}_merge.txt", run = config["run"])
    output:
        expand("results/merge/{run}_final_merged{ext}", ext=[".bed",".bim",".fam",".log",".nosex"], run = config["run"])
    params:
        run = config["run"],
        snp = config["SNP_panel"]
    conda:
        "../envs/smartpca.yaml"
    shell:
        "plink --bfile workflow/files/{params.snp} --merge-list {input.merge} --dog --make-bed --out results/merge/{params.run}_final_merged"

#This rule creates .ped and .map files from binary PLINK input
rule format_input:
    input:
        expand("results/merge/{run}_final_merged{ext}", ext=[".bed",".bim",".fam"], run = config["run"])
    output:
        expand("results/merge/{run}_final_merged{ext}", ext=[".ped",".map",".log",".nosex"], run = config["run"])
    params:
        run = config["run"]
    conda:
        "../envs/smartpca.yaml"
    shell:
        "plink --bfile results/merge/{params.run}_final_merged --dog --recode --out results/merge/{params.run}_final_merged"

#This rule runs smartpca on the merged dataset, projecting unknown samples onto eigenvectors calculated using the referene panel 
rule smartpca:
    input:
        fam = expand("results/merge/{run}_final_merged.fam", run = config["run"]),
        ped = expand("results/merge/{run}_final_merged.ped", run = config["run"]),
        map = expand("results/merge/{run}_final_merged.map", run = config["run"])
    output:
        poplist = expand("results/merge/{run}_final_merged{ext1}", ext1=[".poplist",".poplist.noancient"], run = config["run"]),
        modped = expand("results/merge/mod_{run}_final_merged.ped", run = config["run"]),
        eigen = expand("results/smartpca/{run}_final_merged{ext2}", ext2=[".geno",".snp",".ind",".evec",".eval"], run = config["run"]),
        par = expand("results/smartpca/{run}_par{ext3}", ext3=[".PED.EIGENSTRAT"], run = config["run"]),
        out = expand("results/smartpca/smartpca_{run}.out", run = config["run"])
    params:
        run = config["run"]
    conda:
        "../envs/smartpca.yaml"
    shell:
        "workflow/scripts/smartpca.sh {input.fam} {input.ped} {input.map} {output.out} {params.run}"

#Plots the results of the PCA
rule plot_pca:
    input:
        evec = expand("results/smartpca/{run}_final_merged.evec", run = config["run"]),
        eval = expand("results/smartpca/{run}_final_merged.eval", run = config["run"]),
        stats = expand("results/stats/{run}_all_stats.txt", run = config["run"]),
        status = expand("workflow/files/{taxa}_status.txt", taxa = config["SNP_panel"])
    output:
        expand("results/plots/{run}_PCA_plot.pdf", run = config["run"])
    conda:
        "../envs/lda.yaml"
    shell:
        "Rscript workflow/scripts/PCA.R {input.evec} {input.eval} {output} {input.stats} {input.status}"

#Plots the results of sex identification
rule plot_sexID:
    input:
        stats = expand("results/stats/{run}_all_stats.txt", run = config["run"])
    output:
        pdf = expand("results/plots/{run}_sexID_plot.pdf", run = config["run"]),
        txt = expand("results/plots/{run}_sexID.txt", run = config["run"])
    conda:
        "../envs/lda.yaml"
    shell:
        "Rscript workflow/scripts/sexID.R {input.stats} {output.pdf} {output.txt}"

#This rule uses linear disciminant analysis to calculate assignment probabilities of samples to reference populations
rule LDA:
    input:
        evec = expand("results/smartpca/{run}_final_merged.evec", run = config["run"]),
        status = expand("workflow/files/{taxa}_status.txt", taxa = config["SNP_panel"])
    output:
        expand("results/plots/{run}_posteriors.txt", run = config["run"])
    conda:
        "../envs/lda.yaml"
    shell:
        "Rscript workflow/scripts/LDA.R {input.evec} {output} {input.status}"
