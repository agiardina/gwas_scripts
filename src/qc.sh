#! /bin/bash
##########################################
## Configuration
##########################################
MISS_INDIVIDUALS_RATE=0.02
MISS_SNPS_RATE=0.02
MAF_RATE=0.05
##########################################

plink=`which plink`
if ! test $plink
then
   plink=`which plink1.9`
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
inputbed=$input

echo "STEP ${step}"
echo "-------------------------------"
echo "Removing individuals with missing phenotype" 
echo "-------------------------------"
if [ -n "$keep" ]
then
    outputbed="${output}/genome_${step}_keep"    
    $plink --bfile $inputbed --keep $keep --make-bed --out $outputbed
    ((step++))
    inputbed=$outputbed
fi

echo "STEP ${step}"
echo "-------------------------------"
echo "Generating histograms for individual missingness and SNP missingness"
echo "-------------------------------"
$plink --bfile $inputbed --missing --out $output/plink
Rscript --no-save hist_miss.R $output

((step++))
echo "STEP ${step}"
echo "-------------------------------"
echo "Removing SNPS with missingness >  ${MISS_SNPS_RATE}"
echo "-------------------------------"
outputbed="${output}/genome_${step}_geno"
$plink --bfile $input --geno $MISS_SNPS_RATE --make-bed --out $outputbed

((step++))
echo "STEP ${step}"
echo "-------------------------------"
echo "Removing individual with missingness >  ${MISS_INDIVIDUALS_RATE}"
echo "-------------------------------"
inputbed=$outputbed
outputbed="${output}/genome_${step}_mind"
$plink --bfile $input --mind $MISS_INDIVIDUALS_RATE --make-bed --out $outputbed

((step++))
echo "STEP ${step}"
echo "-------------------------------"
echo "Check for sex discrepancy" 
echo "-------------------------------"

#There isn't any sex chromosome
#$plink --bfile $input --check-sex

((step++))
echo "STEP ${step}"
echo "-------------------------------"
echo "Generate a plot of the MAF distribution"
echo "-------------------------------"
inputbed=$outputbed
$plink --bfile $inputbed --freq --out "${output}/MAF_check"
Rscript --no-save "MAF_check.R" $output

((step++))
echo "STEP ${step}"
echo "-------------------------------"
echo "Remove SNPs with low frequency"
echo "-------------------------------"
inputbed=$outputbed
outputbed="${output}/genome_${step}_maf"
plink --bfile $inputbed --maf $MAF_RATE --make-bed --out $outputbed

((step++))
echo "STEP ${step}"
echo "-------------------------------"
echo "Writes a list of genotype counts and Hardy-Weinberg equilibrium exact test statistics"
echo "-------------------------------"
inputbed=$outputbed
plink --bfile $inputbed --hardy --out $output/plink
