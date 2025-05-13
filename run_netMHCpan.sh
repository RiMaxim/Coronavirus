cat 10.length 8.length 8_10.length 8_9.length 9.length 9_10.length |sort|uniq >tmp1

while read -r id; do
    ./netMHCpan -p tmp1 -a ${id} >>tmp2
done < data4.csv

grep "PEPLIST" tmp2 |grep -v "Protein" |sed 's/ /|/g'|sed 's/|||||||||/\t/g'| sed 's/|||||||/\t/g'| sed 's/||||||/\t/g'| sed 's/|||||/\t/g'| sed 's/||||/\t/g'| sed 's/|||/\t/g'| sed 's/||/\t/g'| sed 's/|/\t/g' |awk -F'\t' '{print $4"\t"$3"\t"$14}' | \
awk -F'\t' '{if($3 <= '$1') print $1"\t"$2}' >tmp3

cut -f 1 tmp3 >tmp4
cut -f 2 tmp3 |awk -F'HLA-' '{print $2}' >tmp5

paste tmp5 tmp4 |awk -F'\t' '{print $1","$2}' >data5.csv

rm tmp*



