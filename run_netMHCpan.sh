cat 10.length 8.length 8_10.length 8_9.length 9.length 9_10.length |awk -F'\t' '{print $1","$2}' >tmp1

awk -F',' 'NR > 1 {
    peptide_full = $2;
    peptide = $1;
    peptide_list[peptide_full] = (peptide_list[peptide_full] == "" ? peptide : peptide_list[peptide_full] "\n" peptide);
}
END {
    for (pep in peptide_list) {
        out_file = "list/" pep;
        gsub(/[^A-Za-z0-9_]/, "_", out_file);
        print peptide_list[pep] > out_file;
    }
}
' tmp1

max_jobs=20
current_jobs=0

for pepfile in list_*; do
    (
        outfile="$(basename "${pepfile%.*}").out"
        > "${outfile}"
        while IFS= read -r hla; do
            hla=$(echo "$hla" | xargs)
            [[ -z "$hla" ]] && continue
            echo ">>> HLA: ${hla}" >> "${outfile}"
            ./netMHCpan -p "${pepfile}" -a "${hla}" >> "${outfile}"
            echo "" >> "${outfile}"
        done < data4.csv
    ) &

    ((current_jobs++))
    if (( current_jobs >= max_jobs )); then
        wait -n
        ((current_jobs--))
    fi
done

wait

for pepfile in list_*.out; do
    tag=$(basename "$pepfile" .out)
    tag=${tag#list_}
    outfile="$(basename "${pepfile}").HLA"
    grep "PEPLIST" ${pepfile} |grep -v "Protein" |sed 's/ /|/g'|sed 's/|||||||||/\t/g'| sed 's/|||||||/\t/g'| sed 's/||||||/\t/g'| sed 's/|||||/\t/g'| sed 's/||||/\t/g'| sed 's/|||/\t/g'| sed 's/||/\t/g'| sed 's/|/\t/g' |awk -F'\t' '{print $3"\t"$14}' | \
    awk -F'\t' '{if($2 <= '$1') print $1}' | \
    awk -F'HLA-' '{print $2}' |sort|uniq |awk -F'\t' -v tag="$tag" '{print $1 "\t" tag}'  >${outfile}
    cat ${outfile} >>tmp2
done

cat tmp2 |awk -F'\t' '{print $1","$2}' >data5.csv
rm tmp* list*



