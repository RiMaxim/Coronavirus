cut -f 1 table.txt > ids.txt

while read -r id; do
    wget -q -O - "http://www.allelefrequencies.net/tools/getrawdata.asp?pop_id=${id}" > ${id}
    ./processing_HLA.sh ${id} tmp1
    grep "${id}" table.txt |awk -F'\t' '{print $4}' > tmp2
    tmp3=$(cat tmp2)
    cat tmp1 | awk -F'\t' -v tmp3="$tmp3" '{print $1"\t"tmp3}' >>tmp4
    rm ${id}
done < ids.txt

rm ids.txt

sed 's/ /_/g' tmp4 >tmp5

#########################################################
cat data5.csv |awk -F',' '{print $1}'|sort|uniq >tmp6

awk '
BEGIN {
    # Read all HLA from the second file into an array
    while ((getline hla < "tmp6") > 0) {
        hla_map[hla] = 1;
    }
    close("tmp6");
}

{
    # Read a line from the first file
    split($1, hla_arr, ",");  # Split by comma
    count = 0;
    
    # Check how many HLA match those in hla_map
    for (i in hla_arr) {
        if (hla_arr[i] in hla_map) {
            count++;
        }
    }


    # Add the match count to the sum for each country
    country_counts[$2] += count;
    country_occurrences[$2]++;
}

END {
    # For each unique country, calculate the average match count
    for (country in country_counts) {
        avg = country_counts[country] / country_occurrences[country];
        print country"\t"avg;
    }
}
' tmp5 | sort -nrk 2 |sed 's/_/ /g' |awk -F'\t' '{print $1","$2}'> data6.csv
#######################################################################

awk -F',' 'NR > 1 {
    peptide = $2;
    hla = $1;
    peptide_hlas[peptide] = (peptide_hlas[peptide] == "" ? hla : peptide_hlas[peptide] "\n" hla);
}
END {
    for (pep in peptide_hlas) {
        out_file = "hla_lists/" pep;
        gsub(/[^A-Za-z0-9_]/, "_", out_file);
        print peptide_hlas[pep] > out_file;
    }
}
' data5.csv


echo hla_lists_* | tr ' ' '\n' > hla_lists.txt


while read -r id; do

awk '
BEGIN {
    # Read all HLA from the second file into an array
    while ((getline hla < "'${id}'") > 0) {
        hla_map[hla] = 1;
    }
    close("'${id}'");
}

{
    # Read a line from the first file
    split($1, hla_arr, ",");  # Split by comma
    count = 0;

    # Check how many HLA match those in hla_map
    for (i in hla_arr) {
        if (hla_arr[i] in hla_map) {
            count++;
        }
    }


    # Add the match count to the sum for each country
    country_counts[$2] += count;
    country_occurrences[$2]++;
}

END {
    # For each unique country, calculate the average match count
    for (country in country_counts) {
        avg = country_counts[country] / country_occurrences[country];
        print country"\t"avg;
    }
}' tmp5 > ${id}.csv

done < hla_lists.txt

for pepfile in hla_lists_*.csv; do
    tag=$(basename "$pepfile" .csv)
    tag=${tag#hla_lists_}
    cat ${pepfile} |awk -F'\t' -v tag="$tag" '{print $1"\t"$2"\t"tag}' >> tmp7
done

cat  tmp7 |awk -F'\t' '{print $1","$2","$3}'|sed 's/_/ /g' >data7.csv

rm tmp* *list*
