#! /bin/bash
plink=`which plink`
if [[ ! $plink ]]
then
   plink=`which plink1.9`
fi

if test $1 && test $2
then
    input_folder=$1
    out=$2
    find $input_folder -maxdepth 1 -name "*.bed" | sort -V | rev | cut -f 2- -d . | rev > mergelist.txt
    $plink --merge-list mergelist.txt -make-bed --out $out
    rm mergelist.txt
else
    echo "input folder and ouput file expected as argument."
    echo "Example:"
    echo "sh combine.sh ../input_bfiles/ ../output_folder/mycombinedgenome"
fi
