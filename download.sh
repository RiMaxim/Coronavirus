cat table.txt |awk -F'\t' '{print $1}' >ids.txt
while read -r id; do
    wget -q -O - "http://www.allelefrequencies.net/tools/getrawdata.asp?pop_id=${id}" >> data.csv
done < ids.txt
