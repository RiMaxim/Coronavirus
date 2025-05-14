download.sh – downloads HLA haplotypes from the Allele Frequencies database (http://www.allelefrequencies.net/BrowseGenotype.aspx) into a single file. A file containing IDs (corresponding to the first column in the website’s table) is required for download.

input.csv – a list of peptides associated with Omicron B.1.1.529 and Wuhan-Hu-1, derived from the article: https://www.cell.com/iscience/fulltext/S2589-0042(25)00133-6. Each peptide is accompanied by an intensity value.

wt – RBD sequence of Wuhan-Hu-1, including a C-terminal AviTag-His tag (ASENLYFQGGTGLNDIFEAQKIEWHETGHHHHHH) and an N-terminal non-RBD leader sequence (AP).

omicron – RBD sequence of Omicron B.1.1.529, including a C-terminal AviTag-His tag (ASENLYFQGGTGLNDIFEAQKIEWHETGHHHHHH) and an N-terminal non-RBD leader sequence (AP).

processing_peptideA.sh – filters the raw peptide data from input.csv.

processing_HLA.sh – filters the raw HLA haplotype data downloaded from the Allele Frequencies database.

global_alleles.py – generates a minimal set of HLA alleles covering 98% of the global HLA haplotype diversity.

separate_length.sh – sorts peptides based on their length.

run_netMHCpan.sh – predicts peptide binding affinity to HLA class I molecules using NetMHCpan 4.1.

population_immunity.sh – calculates the protection index across different countries.
