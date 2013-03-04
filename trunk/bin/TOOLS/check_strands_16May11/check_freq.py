# check_freq.py
import combine_markers

# sample is a list of allele values
def get_freq(sample,alleles,rs):
    possible_alleles = ["A","C","T","G"]
    count = [0,0,0,0]
    for x in sample:
        if x==possible_alleles[0]:
            count[0] += 1
        elif x==possible_alleles[1]:
            count[1] += 1
        elif x==possible_alleles[2]:
            count[2] += 1
        elif x==possible_alleles[3]:
            count[3] += 1
    mycount = [0,0]
    if alleles[0] in possible_alleles:
        mycount[0] = count[possible_alleles.index(alleles[0])]
    if alleles[1] in possible_alleles:
        mycount[1] = count[possible_alleles.index(alleles[1])]
    total_count = count[0]+count[1]+count[2]+count[3]
    if total_count != mycount[0]+mycount[1]:
            print "Markers file does not match observed alleles for marker",rs,"(exiting)"
            raise SystemExit
    return [mycount[0],total_count]


# checks whether frequencies at this marker are consistent, or can be made consistent by change of alleles
# creates dictionary key switch (list of file numbers) if needed
# creates dictionary key bad_freq (value 1) if frequencies don't match
def check_marker(marker_item,diff_threshold,log_file,filenames):
    good_files = marker_item.get_goodfiles()
    if len(good_files)<2:
        return
    freq_info = []
    for filenbr in good_files:
            alleles = marker_item.get_refAlleles()[:]
	    if marker_item.needs_switch(filenbr):
                alleles[0] = combine_markers.single_switch(alleles[0])
                alleles[1] = combine_markers.single_switch(alleles[1])
            if not marker_item.has_genotypes(filenbr):
                print >> log_file, "unable to find genotypes for marker",marker_item.get_snpname(),"in file",filenbr
            sample = marker_item.get_genotypes(filenbr)
            freq_info.append((filenbr,get_freq(sample,alleles,marker_item.get_snpname()),alleles))
    for i in range(0,len(freq_info)-1):
      if i in marker_item.get_badfiles():
        continue
      if freq_info[i][1][1]==0:
        print >> log_file, "all missing",marker_item.get_snpname(),filenames[i]
        continue
      for j in range(i+1,len(freq_info)):
        if j in marker_item.get_badfiles():
            continue
        if freq_info[j][1][1]==0:
            print >> log_file, "all missing",marker_item.get_snpname(),filenames[j] 
            continue
        freq_diff1 = abs(float(freq_info[j][1][0])/freq_info[j][1][1] - float(freq_info[i][1][0])/freq_info[i][1][1])
        current_orientation_ok = freq_diff1 < diff_threshold
        new_freq2 = [ freq_info[j][1][1] - freq_info[j][1][0], freq_info[j][1][1] ]
        freq_diff2 = abs(float(freq_info[i][1][0])/freq_info[i][1][1] - float(new_freq2[0])/new_freq2[1])
        reverse_orientation_ok = freq_diff2 < diff_threshold
        filenbr = freq_info[j][0]
        if not reverse_orientation_ok:
            if marker_item.allows_switch(filenbr):
                marker_item.unset_switchAllowed(filenbr)
        if not current_orientation_ok:
            # consider switching if allowed and not already done
            if marker_item.allows_switch(filenbr) and not marker_item.needs_switch(filenbr):
                marker_item.set_switchNeeded(filenbr)
                print >> log_file, marker_item.get_snpname(),"needs switch - discovered by frequency"
                freq_info[j][1][0] = new_freq2[0]
            else:
                print >> log_file, "incompatible frequencies",marker_item.get_snpname(),filenames[freq_info[i][0]],filenames[filenbr],float(freq_info[i][1][0])/freq_info[i][1][1],float(freq_info[j][1][0])/freq_info[j][1][1]
                marker_item.set_badfile(filenbr)
        
                        
      

def checkFreq(markerInfoByRs,diff_threshold,log_file,filenames):
    
    for marker_item in markerInfoByRs.values():
        check_marker(marker_item,diff_threshold,log_file,filenames)
        
    print "done checking frequencies"    
