download.sh – downloads HLA haplotypes from Allele Frequencies (http://www.allelefrequencies.net/BrowseGenotype.aspx) into a single file. A file with IDs (the first column in the table on the website) is required for downloading.

processing.sh – filters the raw file with HLA haplotypes downloaded from Allele Frequencies.

global_alleles.py – generates a minimal list of alleles covering 98% of HLA haplotypes.

Omicron_peptides.csv – a list of peptides associated with Omicron from the article https://www.cell.com/iscience/fulltext/S2589-0042(25)00133-6

separate_length.sh - script for sorting peptides by length

run_netMHCpan.sh - a script for predicting peptide binding to HLA class I.
