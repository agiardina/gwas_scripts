#! /bin/bash
if [[ -z "${PLINK_PATH}" ]]
then
    plink=`which plink1.9 | which plink1 | which plink`
else
    plink=$PLINK_PATH
fi


if test $1 && test $2 && test $3
then
    input=$1
    ref=$2
    output=$3
    bim="${1}.bim"
    extract="${output}.extract"
    awk '{print $1" "$4" "$4" "$2}' $bim > $extract
    plink -bfile $ref --extract range $extract --allow-no-sex --indiv-sort 0 --make-bed --out $output    
else
    cat << EOF
The extractref script select variants from chrN.bim/bed/fam reference 
files using PLINK extended MAP file as input. All arguments are without extension.

Usage:
	bash extractref.sh inputfile referefencefile outputfile 
EOF

fi

