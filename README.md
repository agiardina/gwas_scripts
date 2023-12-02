# GWAS Script

This repository has been created to save some useful scripts to run GWA analysis and quality control. 
The code has been adapted by [https://github.com/MareesAT/GWA_tutorial/tree/master]. The changes to the code have been introduced to increase the reusability of the scripts. 
These scripts has been designed to run on a unix-like system, an assume **Plink** and **R** are properly installed on the system.
There are two main scripts:
- **combine.sh** to combine multiple bed files in one big bed file.
- **qc.sh** to run semi-automatic quality control over a genotype file in bed format. The scripts run multiple steps. The output of each step is the input of the following step. The script has been designed to keep track of each step so that each intermediary output file will be saved in the output directory. Pay attention: **if the input file is big the size of the output directory can increase very fast**.

## How to use
In the **src** folder there are the following scripts:
### combine.sh
	./combine.sh input_folder output_file_without_extension
### qc.sh
	./qc.sh my_file_without_extension my_output_directory
