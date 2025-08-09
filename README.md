# 1. Dependencies

>Linux (tested on Ubuntu 24.04.2 LTS)
>
>Python 3.12.2
>
>NetMHCpan 4.1 (License Required: NetMHCpan is free for academic use but requires registration). Go to the official NetMHCpan 4.1 page ([https://services.healthtech.dtu.dk/services/NetMHCpan-4.1/](https://services.healthtech.dtu.dk/cgi-bin/sw_request?software=netMHCpan&version=4.1&packageversion=4.1b&platform=Linux)). Fill out the form with academic email (e.g., @university.edu) and institutional details. Check your email for the download link (subject: NetMHCpan download instructions).
>
>download file https://services.healthtech.dtu.dk/services/NetMHCpan-4.1/data.tar.gz (required for NetMHCpan)
>
>install tcsh (required for NetMHCpan)
>
>install gawk (GNU Awk, used in processing scripts)  



# 2. Download and Install

**Download the archive (replace URL only for netMHCpan-4.1b.Linux.tar.gz with the one sent to your email)**
>wget https://services.healthtech.dtu.dk/download/35b3498a-39ab-44df-b680-d8b6d5d0c43b/netMHCpan-4.1b.Linux.tar.gz
>
>wget https://services.healthtech.dtu.dk/services/NetMHCpan-4.1/data.tar.gz

**Extract**
>tar -xvzf netMHCpan-4.1b.Linux.tar.gz
>
>tar -xvzf data.tar.gz

**Check if tcsh is installed**
>which tcsh || echo "tcsh is not installed"

**Install tcsh (with root privileges)**
>sudo apt install tcsh

**Local installation (without root access)**
>wget ftp://ftp.astron.com/pub/tcsh/tcsh-6.24.07.tar.gz
>
>tar xvzf tcsh-6.24.07.tar.gz
>
>cd tcsh-6.24.07
>
>./configure --prefix=$HOME/.local
>
>make && make install
>
>export PATH=$HOME/.local/bin:$PATH

**Check if gawk is installed**
>gawk --version  # Should show GNU Awk 5.0+

**Install gawk (with root privileges)**
>sudo apt install gawk
>
>wget https://ftp.gnu.org/gnu/gawk/gawk-5.3.2.tar.gz
>
>tar xvzf gawk-5.3.2.tar.gz
>
>cd gawk-5.3.2/  # Version may vary
>
>./configure --prefix=$HOME/.local
>
>make && make install
>
>export PATH=$HOME/.local/bin:$PATH



# 3. Input Files

**table.txt** – List of HLA genotype IDs (from Allele Frequencies Database).

**input.csv** – a list of peptides associated with Omicron B.1.1.529 and Wuhan-Hu-1, derived from the article: https://www.cell.com/iscience/fulltext/S2589-0042(25)00133-6. Each peptide is accompanied by an intensity value.

**wt** – Wuhan-Hu-1 RBD sequence, including a C-terminal AviTag-His tag (ASENLYFQGGTGLNDIFEAQKIEWHETGHHHHHH) and an N-terminal non-RBD leader sequence (AP).

**omicron** – Omicron B.1.1.529 RBD sequence (same tag format).



# 4. Pipeline Workflow
A computational pipeline for analyzing peptide binding affinity to HLA class I alleles and estimating population immunity.

Step 1: Download HLA Haplotypes from the Allele Frequencies database (http://www.allelefrequencies.net/BrowseGenotype.aspx) into a single file. A file containing IDs (corresponding to the first column in the website’s table - table.txt) is required for download.

>./download.sh





processing_peptideA.sh – filters the raw peptide data from input.csv.

processing_HLA.sh – filters the raw HLA haplotype data downloaded from the Allele Frequencies database.

global_alleles.py – generates a minimal set of HLA alleles covering 98% of the global HLA haplotype diversity.

separate_length.sh – sorts peptides based on their length.

run_netMHCpan.sh – predicts peptide binding affinity to HLA class I molecules using NetMHCpan 4.1.

population_immunity.sh – calculates the protection index across different countries.
