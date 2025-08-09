# Quick start by Linux (tested on Ubuntu 24.04.2 LTS)

>git clone https://github.com/RiMaxim/Coronavirus.git
>
>cd Coronavirus
>
>chmod +x *sh *py
>
>./[![install_tcsh_gawk.sh](https://img.shields.io/badge/install_tcsh_gawk.sh-red)](https://github.com/RiMaxim/Coronavirus/blob/main/install_tcsh_gawk.sh) 
>
> Go to the official NetMHCpan 4.1 page ([https://services.healthtech.dtu.dk/services/NetMHCpan-4.1/](https://services.healthtech.dtu.dk/cgi-bin/sw_request?software=netMHCpan&version=4.1&packageversion=4.1b&platform=Linux)). Fill out the form with academic email (e.g., @university.edu) and institutional details. Check your email for the copy link
>
>./[![run_full_pipeline.sh](https://img.shields.io/badge/run_full_pipeline.sh-red)](https://github.com/RiMaxim/Coronavirus/blob/main/run_full_pipeline.sh) In the second line, replace the link from previos step.


# 1. Dependencies

>Linux (tested on Ubuntu 24.04.2 LTS)
>
>Python 3.12.2
>
>NetMHCpan 4.1 (License Required: NetMHCpan is free for academic use but requires registration). Go to the official NetMHCpan 4.1 page ([https://services.healthtech.dtu.dk/services/NetMHCpan-4.1/](https://services.healthtech.dtu.dk/cgi-bin/sw_request?software=netMHCpan&version=4.1&packageversion=4.1b&platform=Linux)). Fill out the form with academic email (e.g., @university.edu) and institutional details. Check your email for the download link (subject: NetMHCpan download instructions).
>
>download file https://services.healthtech.dtu.dk/services/NetMHCpan-4.1/data.tar.gz (required for NetMHCpan)
>
>install tcsh (required for NetMHCpan). Run the script  [![install_tcsh_gawk.sh](https://img.shields.io/badge/install_tcsh_gawk.sh-red)](https://github.com/RiMaxim/Coronavirus/blob/main/install_tcsh_gawk.sh) The script checks for sudo privileges. If no privileges are available, it installs tcsh and gawk locally in $HOME/.local It adds the path to $PATH via ~/.bashrc (if not already present).
>
>install gawk (GNU Awk, used in processing scripts). Run the script  [![install_tcsh_gawk.sh](https://img.shields.io/badge/install_tcsh_gawk.sh-red)](https://github.com/RiMaxim/Coronavirus/blob/main/install_tcsh_gawk.sh) The script checks for sudo privileges. If no privileges are available, it installs tcsh and gawk locally in $HOME/.local. It adds the path to $PATH via ~/.bashrc (if not already present).



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



# 3. NetMHCpan-4.1 Configuration Note

After installation, edit line 14 of the netMHCpan executable to point to your installation directory.



# 4. Input Files

 [![table.txt](https://img.shields.io/badge/table.txt-green)](https://github.com/RiMaxim/Coronavirus/blob/main/table.txt) – List of HLA genotype IDs (from Allele Frequencies Database).

 [![input.csv](https://img.shields.io/badge/input.csv-green)](https://github.com/RiMaxim/Coronavirus/blob/main/input.csv) – a list of peptides associated with Omicron B.1.1.529 and Wuhan-Hu-1, derived from the article: https://www.cell.com/iscience/fulltext/S2589-0042(25)00133-6. Each peptide is accompanied by an intensity value.

 [![wt](https://img.shields.io/badge/wt-green)](https://github.com/RiMaxim/Coronavirus/blob/main/wt) – Wuhan-Hu-1 RBD sequence, including a C-terminal AviTag-His tag (ASENLYFQGGTGLNDIFEAQKIEWHETGHHHHHH) and an N-terminal non-RBD leader sequence (AP).

 [![omicron](https://img.shields.io/badge/omicron-green)](https://github.com/RiMaxim/Coronavirus/blob/main/omicron) – Omicron B.1.1.529 RBD sequence (same tag format).



# 5. Pipeline Workflow
A computational pipeline for analyzing peptide binding affinity to HLA class I alleles and estimating population immunity. See the full description in the article in section 19-30.

**Step 1:** Download HLA Haplotypes from the Allele Frequencies database (http://www.allelefrequencies.net/BrowseGenotype.aspx) into a single file. A file containing IDs (corresponding to the first column in the website’s table - table.txt) is required for download. Output file is data.csv

>./[![download.sh](https://img.shields.io/badge/download.sh-red)](https://github.com/RiMaxim/Coronavirus/blob/main/download.sh)

**Step 2:** Filter the raw peptides from input.csv. Output file is peptide.csv

>./[![processing_peptideA.sh](https://img.shields.io/badge/processing_peptideA.sh-red)](https://github.com/RiMaxim/Coronavirus/blob/main/processing_peptideA.sh)

**Step 3:** Filter the raw HLA haplotype data downloaded from the Allele Frequencies database.

>./[![processing_HLA.sh](https://img.shields.io/badge/processing_HLA.sh-red)](https://github.com/RiMaxim/Coronavirus/blob/main/processing_HLA.sh) data.csv data2.csv

**Step 4:** Select Global HLA Alleles (98% Coverage).

>python3 ./[![global_alleles.py](https://img.shields.io/badge/global_alleles.py-red)](https://github.com/RiMaxim/Coronavirus/blob/main/iglobal_alleles.py) data2.csv data3.csv

**Step 5:** Sort Peptides by Length. This example demonstrates the process of analysis run on peptides derived from the Omicron B.1.1.529 RBD antigen. Output files are 8.length, 8_9.length, 8_10.length, 9.length, 9_10.length and 10.length

>./[![separate_length.sh](https://img.shields.io/badge/separate_length.sh-red)](https://github.com/RiMaxim/Coronavirus/blob/main/separate_length.sh) peptide.csv omicron

**Step 6:** Organize the list of alleles to match the algorithm’s required format.
>awk -F'*' '{print "HLA-"$1$2}' data3.csv >data4.csv

**Step 7:** Predict HLA Binding (NetMHCpan-4.1). As an argument, you will obtain a numerical value representing the binding rank threshold. Peptide-HLA class I pairs with a binding rank above this threshold are removed. By default, the binding rank threshold for strongly binding peptides is 0.5. The program returns a list of HLA class I alleles and the corresponding peptides that exhibit strong binding, with a rank below 0.5. Output file is data5.csv 

>./[![run_netMHCpan.sh](https://img.shields.io/badge/run_netMHCpan.sh-red)](https://github.com/RiMaxim/Coronavirus/blob/main/run_netMHCpan.sh) 0.5

**Step 8:** Calculate Population Immunity across different countries. The resulting table (data6.csv) with a list of 27 countries is sorted from the highest to the lowest index value (column 2). The number of countries may vary, depending on the file table.txt from the step 17. The resulting table (data7.csv) contains three columns: country, index value, and peptide.

>./[![population_immunity.sh](https://img.shields.io/badge/population_immunity.sh-red)](https://github.com/RiMaxim/Coronavirus/blob/main/population_immunity.sh)


# 6. Check Protection Index Against RBD Omicron with Telegram Bot in a second

Do you know that now you can check immune defense against the RBD Omicron variant using a simple Telegram bot? Meet @Protection_index_bot – a handy tool that calculates protection index based on HLA class I haplotype in a second!
