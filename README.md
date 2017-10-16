# Calculating-haplotype-SNP
Calculating haplotype SNP from  bam file by calculating depth of  specify haplotype position
* considering two position within one reads
* considering two position in pair reads

Ex: </br>
sortbamfile="/home/ywliao/project/company/Haploid/test.bam" #input bam file </br>
haploid_pos="/home/ywliao/project/company/Haploid/haploid_pos.txt" #input haplotype position file: chr,position1,postion2;tab separated </br>
haploid_awk="/home/ywliao/project/company/Haploid/haploid_count_bam.awk" </br>
haploid_file=$outdir"test"".haploid.txt" #output file </br>
samtools view $sortbamfile | $haploid_awk $haploid_pos - | sort -k1,1 -k 2,2n > $haploid_file </br>
