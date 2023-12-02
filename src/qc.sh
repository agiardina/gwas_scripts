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
    echo "Error: Specify input file (prefix) and ouput directory" 
    echo "Usage: qc.sh my_file my_output_directory"
    exit 1
fi

input=$1
output=$2

step=1
echo "STEP ${step}"
echo "-------------------------------"
echo "Generating histograms for individual missingness and SNP missingness"
echo "-------------------------------"
$input_bed=$input
$plink --bfile $input_bed --missing --out $output/plink
Rscript --no-save hist_miss.R $output

((step++))
echo "STEP ${step}"
echo "-------------------------------"
echo "Removing SNPS with missingness >  ${MISS_SNPS_RATE}"
echo "-------------------------------"
$output_bed="${output}/genome_${step}"
$plink --bfile $input --geno $MISS_SNPS_RATE --make-bed --out $output_bed

((step++))
echo "STEP ${step}"
echo "-------------------------------"
echo "Removing individual with missingness >  ${MISS_INDIVIDUALS_RATE}"
echo "-------------------------------"
$input_bed=$output_bed
$output_bed="${output}/genome_${step}"
$plink --bfile $input --mind $MISS_INDIVIDUALS_RATE --make-bed --out $output_bed

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
$input_bed=$output_bed
$plink --bfile $input_bed --freq --out "${output}/MAF_check"
Rscript --no-save "MAF_check.R" $output

((step++))
echo "STEP ${step}"
echo "-------------------------------"
echo "Remove SNPs with low frequency"
echo "-------------------------------"
$input_bed=$output_bed
$output_bed="${output}/genome_${step}"
plink --bfile $input_bed --maf $MAF_RATE --make-bed --out $output_bed
