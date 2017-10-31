#!/bin/awk -f

BEGIN{
	FS="\t"
	OFS="\t"
	pattern = "([0-9][0-9]*)([SMDIH])"
	tmp_chr = ""
    }
NR == FNR{
	chr_map[$1]++
	map[$1":"chr_map[$1]] =$2":"$3 
	}
NR != FNR{
	if ($3 in chr_map){
		if($3 != tmp_chr){
			idx_hap = 1
			tmp_chr = $3
                        hap = map[$3":"idx_hap]
			split(hap,array,":")
			pos1 = array[1]
			pos2 = array[2]
			}
		seqname = $1
		cigar = $6
                pos = $4
	        frag_len = $9 > 0 ? $9:-$9
		raw_seq =$10
		if (pos <= pos1 && pos + frag_len > pos2 && cigar != "*" || frag_map[seqname]){
			seq = ""
			mv_seq = 1
			mv_cigar = 1
                 while(mv_cigar -1 < length(cigar)){
			    cigar = substr(cigar,mv_cigar)
			    raw_seq = substr(raw_seq,mv_seq)
			    match(cigar,pattern,cig_inf)
			    if (cig_inf[2] == "M"){
				    seq = seq""substr(raw_seq,1,cig_inf[1])
					mv_seq = cig_inf[1] +1
				    }
				else if (cig_inf[2] == "S" || cig_inf[2] == "I"){
					mv_seq = cig_inf[1]	+1				
					}
				else if (cig_inf[2] == "H"){
					}
				else if (cig_in[2] == "D"){
					del = "*"
				    for (i=1;i<cig_inf[1];i++){
						del = del"*"
						}
					seq = seq""del
					}
           	    mv_cigar = cig_inf[0,"length"]+1
		           }
			seq_true_len = length(seq)
			if (pos + seq_true_len -1 >= pos2 || frag_map[seqname]){
		        if(!frag_map[seqname]){
				    pos1_base = substr(seq,pos1 - pos +1,1)
				    pos2_base = substr(seq,pos2 - pos +1,1)
				    haploid_map[tmp_chr":"pos1","pos2","pos1_base","pos2_base]++
				    }
				else{
                    read1_inf = frag_map[seqname]
				    split(read1_inf,read1_array,":")
					r1_pos1 = read1_array[1]
                    pos1_base = read1_array[2]
					r1_pos2 = read1_array[3]
					if(pos + seq_true_len -1 >= r1_pos2){
				        pos2_base = substr(seq,r1_pos2 - pos +1,1)
					    haploid_map[tmp_chr":"r1_pos1","r1_pos2","pos1_base","pos2_base]++
					    }
					}
		    }
			else if(pos + seq_true_len -1 >= pos1){
				seqname = $1
			    pos1_base = substr(seq,pos1 - pos +1,1)
				frag_map[seqname] = pos1":"pos1_base":"pos2
				}
		}
		else if(pos > pos1){
			idx_hap++
                       if(map[$3":"idx_hap]){
                            hap = map[$3":"idx_hap]
			    split(hap,array,":")
			    pos1 = array[1]
			    pos2 = array[2]
			}
			}
}
}
END{
	for(haploid in haploid_map){
		split(haploid,inf,":")
		chr = inf[1]
		split(inf[2],base_inf,",")
		pos1 = base_inf[1]
		pos2 = base_inf[2]
		pos1_base = base_inf[3]
		pos2_base = base_inf[4]
		print chr"\t"pos1"\t"pos2"\t"pos1_base"\t"pos2_base"\t"haploid_map[haploid]
		}
	}
