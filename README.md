# Calculating-haplotype-SNP
Calculating haplotype SNP from  bam file by calculating depth of  specify haplotype position
* considering two position within one reads
* considering two position in pair reads

Ex: </br>
```
sortbamfile="/home/ywliao/project/company/Haploid/test.bam" #input sorted bam file 
haploid_pos="/home/ywliao/project/company/Haploid/haploid_pos.txt" #input haplotype position file: chr,position1,postion2;tab separated;should be sorted
haploid_awk="/home/ywliao/project/company/Haploid/haploid_count_bam.awk" 
haploid_file=$outdir"test"".haploid.txt" #output file 
samtools view $sortbamfile | $haploid_awk $haploid_pos - | sort -k1,1 -k 2,2n > $haploid_file
#or filter haploid snp covered by less than 30% of reads
samtools view $sortbamfile | $haploid_awk $haploid_pos - | awk 'BEGIN{
FS="\t";OFS="\t"}{
pos[$1","$2","$3]+=$6;haploid[$1","$2","$3","$4","$5","$6]=1}
END{
for(hap in haploid){
    split(hap,array,",");if(array[6]/pos[array[1]","array[2]","array[3]] > 0.3)print array[1],array[2],array[3],array[4],array[5],array[6],array[6]/pos[array[1]","array[2]","array[3]]}
}' | sort -k1,1 -k2,2n > $haploid_file


```
