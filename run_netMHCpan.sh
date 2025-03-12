cat 10.length 8.length 8_10.length 8_9.length 9.length 9_10.length |sort|uniq >tmp1

while read -r id; do
    ./netMHCpan -p tmp1 -a ${id} >>tmp2
done < data4.csv

grep "PEPLIST" tmp2 |grep -v "Protein" |sed 's/ /|/g'|sed 's/|||||||||/\t/g'| sed 's/|||||||/\t/g'| sed 's/||||||/\t/g'| sed 's/|||||/\t/g'| sed 's/||||/\t/g'| sed 's/|||/\t/g'| sed 's/||/\t/g'| sed 's/|/\t/g' |awk -F'\t' '{print $4"\t"$3"["$14"]""\t"$3"\t"$14}' | \
awk -F'\t' '{if($4 <= '$1') print $1"\t"$3}' | \
awk -F'\tHLA-' '{print $2}' | sort |uniq >data5.csv

rm tmp*



