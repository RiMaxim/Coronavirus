cat $1 |awk -F',' '{if($6 == "Wuhan-Hu-1 and Omicron B.1.1.529") print $1}' >>wt.list
cat $1 |awk -F',' '{if($6 == "Wuhan-Hu-1") print $1}' >>wt.list

cat $1 |awk -F',' '{if($6 == "Wuhan-Hu-1 and Omicron B.1.1.529") print $1}' >>omicron.list
cat $1 |awk -F',' '{if($6 == "Omicron B.1.1.529") print $1}' >>omicron.list

cat $2.list |awk -F'\t' '{if(length($1) > '7' && length($1) < '17') print $1}' >tmp1

cat tmp1 |awk -F'\t' '{if(length($1) == '8') print $1"\t"$1}' >8.length

cat tmp1 |awk -F'\t' '{if(length($1) == '9') print $1}' >tmp2
cat tmp2 |awk -F'\t' '{print $1"\t"$2}' >9.length
awk '{print substr($1,2); }' tmp2 >tmp3
paste tmp3 tmp2 >8_9.length

cat tmp1 |awk -F'\t' '{if(length($1) > '9') print $1}' >tmp4
awk '{print substr($1,length($1)-7,8) }' tmp4 >tmp5
paste tmp5 tmp4 >8_10.length
awk '{print substr($1,length($1)-8,9) }' tmp4 >tmp6
paste tmp6 tmp4 >9_10.length
awk '{print substr($1,length($1)-9,10) }' tmp4 >tmp7
paste tmp7 tmp4 >10.length

rm tmp* omicron.list wt.list
