#! /bin/bash
##########################################
## Configuration
##########################################
MISS_INDIVIDUALS_RATE=0.02
MISS_SNPS_RATE=0.02
MAF_RATE=0.05
##########################################

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [[ -z "${PLINK_PATH}" ]]
then
    plink=`which plink1.9 | which plink1 | which plink`
else
    plink=$PLINK_PATH
fi

if [[ -z "${RSCRIPT_PATH}" ]]
then
    Rscript=`which RScript`
else
    Rscript=$RSCRIPT_PATH
fi


if ! test $1 || ! test $2
then
    echo "Error: Specify input file (prefix), ouput directory and optionally keep file." 
    echo "Usage: qc.sh my_file my_output_directory [keep_file]"
    exit
fi

input=$1
output=$2
keep=$3

step=1

echo "STEP ${step}"
echo "-------------------------------"
echo "Removing individuals with missing phenotype" 
echo "-------------------------------"
if [ -n "$keep" ]
then
    outputbed="${output}/genome_${step}_keep"    
    $plink --bfile $input --keep $keep --make-bed --out $outputbed
    input=$outputbed
    ((step++))    
fi

echo "-------------------------------"
echo "Generating histograms for individual missingness and SNP missingness"
echo "-------------------------------"
$plink --bfile $input --missing --out $output/plink
 --no-save $script_dir/hist_miss.R $output

echo "-------------------------------"
echo "Removing SNPS with missingness >  ${MISS_SNPS_RATE}"
echo "-------------------------------"
outputbed="${output}/genome_${step}_geno"
$plink --bfile $input --geno $MISS_SNPS_RATE --make-bed --out $outputbed
input=$outputbed && ((step++))

echo "-------------------------------"
echo "Removing individual with missingness >  ${MISS_INDIVIDUALS_RATE}"
echo "-------------------------------"
outputbed="${output}/genome_${step}_mind"
$plink --bfile $input --mind $MISS_INDIVIDUALS_RATE --make-bed --out $outputbed
input=$outputbed && ((step++))

echo "-------------------------------"
echo "Check for sex discrepancy" 
echo "-------------------------------"

#There isn't any sex chromosome
#$plink --bfile $input --check-sex


echo "-------------------------------"
echo "Generate a plot of the MAF distribution"
echo "-------------------------------"
$plink --bfile $input --freq --out "${output}/MAF_check"
$Rscript --no-save $script_dir/MAF_check.R $output

echo "-------------------------------"
echo "Remove SNPs with low frequency"
echo "-------------------------------"
outputbed="${output}/genome_${step}_maf"
$plink --bfile $input --maf $MAF_RATE --make-bed --out $outputbed
input=$outputbed && ((step++))

echo "-------------------------------"
echo "Writes a list of genotype counts and Hardy-Weinberg equilibrium exact test statistics"
echo "-------------------------------"
$plink --bfile $input --hardy --out $output/plink
