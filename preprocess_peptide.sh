awk -F',' '
NR == 0 { next }  # skip the header if it exists
{
    key = $1 FS $2 FS $3
    sum[key] += $4
    count[key]++
}
END {
    for (key in sum) {
        avg = sum[key] / count[key]
        split(key, fields, FS)
        printf "%s,%s,%s,%.14f\n", fields[1], fields[2], fields[3], avg
    }
}
' input.csv >tmp

###################

awk -F',' '
BEGIN {
    OFS = "\t"
}

{
    peptide = $1
    variant = $2
    condition = ($3 == "HeLa i20S") ? "HeLa c20S" : $3

    if (condition == "control") {
        # General group "Total value for the control group" — sum across all variants
        group = "Total value for the control group"
        sum[peptide][group] += $4
    } else {
        group = variant
        sum[peptide][group] += $4
        count[peptide][group] += 1
    }

    peptides[peptide]
    groups[group]
}

END {
    # Header
    printf "%s", "Peptide"
    for (g in groups) header[g] = g
    n = asort(header, sorted_groups)
    for (i = 1; i <= n; i++) printf "\t%s", sorted_groups[i]
    print ""

    # Values
    for (p in peptides) {
        printf "%s", p
        for (i = 1; i <= n; i++) {
            g = sorted_groups[i]
            if (g == "Total value for the control group") {
                printf "\t%.14f", (sum[p][g] ? sum[p][g] : 0)
            } else {
                if (count[p][g])
                    printf "\t%.14f", sum[p][g] / count[p][g]
                else
                    printf "\t0"
            }
        }
        print ""
    }
}
' tmp |awk -F'\t' '{if($3 == 0) print $1","$4","$2}' >tmp2

##############

cat tmp2 |awk -F',' '{print $1}' |awk '{gsub(/L|I/, "[LI]"); print "grep -oP "$0" wt|| echo -"}' >wt.sh
cat tmp2 |awk -F',' '{print $1}' |awk '{gsub(/L|I/, "[LI]"); print "grep -oP "$0" omicron|| echo -"}' >omicron.sh
chmod +x wt.sh omicron.sh
./wt.sh >tmp3
./omicron.sh >tmp4

##############

while read -r a; do
    while read -r id; do
        awk -v a="$a" -v b="$id" 'BEGIN{print index(a,b)}'
    done < tmp3
done < wt |awk -F'\t' '{print $1+329}' >tmp5


while read -r a; do
    while read -r id; do
        awk -v a="$a" -v b="$id" 'BEGIN{print index(a,b)}'
    done < tmp4
done < omicron |awk -F'\t' '{print $1+329}' >tmp6

cat tmp2|awk -F',' '{print $2"\t"$3}' >tmp7
paste tmp3 tmp4 tmp5 tmp6 tmp7 >tmp8

cat tmp8 |awk -F'\t' '{if($1==$2) print $1"\t"$3"\t"length($1)+$3-1"\t"$5"\t"$6}' |awk -F'\t' '{if($3 <= "528") print $0"\t""Wuhan-Hu-1 and Omicron B.1.1.529"}' >>tmp9
cat tmp8 |awk -F'\t' '{if($2 == "-") print $1"\t"$3"\t"$3+length($1)-1"\t"$5"\t"$6}'|awk -F'\t' '{if($3 <= "528") print $0"\t""Wuhan-Hu-1"}' >>tmp9
cat tmp8 |awk -F'\t' '{if($1 == "-") print $2"\t"$4"\t"$4+length($2)-1"\t"$5"\t"$6}'|awk -F'\t' '{if($3 <= "528") print $0"\t""Omicron B.1.1.529"}' >>tmp9

cat tmp9 |awk -F'\t' '{print $1","$2","$3","$4","$5","$6}' >peptide.csv

rm tmp* wt.sh omicron.sh




