########################
### Step 1: Define   ### 
###  Dictionaries    ###
########################

import pandas as pd

#Import config file and add headers
df=pd.read_csv(config["files"], header=None, skip_blank_lines=True, sep=r'\s+', engine='python')
df.columns=["Library","Sample_ID","Library_Status","Read_Path"]

#Define dictionaries
PATHS=dict(zip(df.Library, df.Read_Path))
LIBRARIES=dict(zip(df.Library, df.Sample_ID))
TYPES=dict(zip(df.Library, df.Library_Status))
SAMPLES=dict(zip(df.Sample_ID, df.Library))

#Create single- and paired-end lists
SE_LIBS = [lib for lib, t in TYPES.items() if t == "SE"]
PE_LIBS = [lib for lib, t in TYPES.items() if t == "PE"]

#This rule creates a file containing labels for all autosomes, sex chromosomes and mtDNA
rule chr_label:
    output:
        labels = "workflow/files/chromosomes.txt"
    params:
        nchrom = config["chromosomes"],
            female = config["femaleID"],
                male = config["maleID"],
                    mtdna = config["mtDNAID"]
    shell:
        "workflow/scripts/chrom_label.sh {params.nchrom} {params.female} {params.male} {params.mtdna}"
