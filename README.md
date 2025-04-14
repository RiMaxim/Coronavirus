download.sh – downloads HLA haplotypes from Allele Frequencies (http://www.allelefrequencies.net/BrowseGenotype.aspx) into a single file. A file with IDs (the first column in the table on the website) is required for downloading.

input.csv – a list of peptides associated with Omicron B.1.1.529 and Wuhan-Hu-1 from the article https://www.cell.com/iscience/fulltext/S2589-0042(25)00133-6 There is intensity for each peptide.

wt - RBD sequence for Wuhan-Hu-1 with C-terminal AviTag-His (ASENLYFQGGTGLNDIFEAQKIEWHETGHHHHHH), N-terminal non-RBD leader sequence (AP)

omicron - RBD sequence for Omicron B.1.1.529 with C-terminal AviTag-His (ASENLYFQGGTGLNDIFEAQKIEWHETGHHHHHH), N-terminal non-RBD leader sequence (AP)

processing_peptideA.sh – filters the raw file (input.csv).

processing_HLA.sh – filters the raw file with HLA haplotypes downloaded from Allele Frequencies.

global_alleles.py – generates a minimal list of alleles covering 98% of HLA haplotypes.

separate_length.sh - script for sorting peptides by length

run_netMHCpan.sh - a script for predicting peptide binding to HLA class I.
