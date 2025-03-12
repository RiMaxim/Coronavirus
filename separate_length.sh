cat $1 |awk -F'\t' '{if(length($1) > '7' && length($1) < '17') print $1}' >tmp1
cat tmp1 |awk -F'\t' '{if(length($1) == '8') print $1}' >length_8
cat tmp1 |awk -F'\t' '{if(length($1) == '9') print $1}' >length_9.1
awk '{print substr($1,2); }' length_9.1 >length_9.2
cat tmp1 |awk -F'\t' '{if(length($1) > '9') print $1}' >tmp2
awk '{print substr($1,length($1)-7,8) }' tmp2 >length_10.3
awk '{print substr($1,length($1)-8,9) }' tmp2 >length_10.2
awk '{print substr($1,length($1)-9,10) }' tmp2 >length_10.1
rm tmp*
