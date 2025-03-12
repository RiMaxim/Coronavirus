cat $1 |awk -F'\t' '{if(length($1) > '7' && length($1) < '17') print $1}' >tmp1
cat tmp1 |awk -F'\t' '{if(length($1) == '8') print $1}' >8.length
cat tmp1 |awk -F'\t' '{if(length($1) == '9') print $1}' >9.length
awk '{print substr($1,2); }' 9.length >8_9.length
cat tmp1 |awk -F'\t' '{if(length($1) > '9') print $1}' >tmp2
awk '{print substr($1,length($1)-7,8) }' tmp2 >8_10.length
awk '{print substr($1,length($1)-8,9) }' tmp2 >9_10.length
awk '{print substr($1,length($1)-9,10) }' tmp2 >10.length
rm tmp*
