# check_LD.py

# to calculate r of two sets of genotypes
# first convert to allele dosage (0,1,2)
# then calculate r

#from rpy import *
from math import sqrt

def remove_missing(genotypes1,genotypes2,alleles1,alleles2):
    if len(genotypes1)%2 != 0 or len(genotypes2)%2 !=0:
        print "genotypes should have length divisible by 2 (exiting)"
        raise SystemExit
    n_indiv = len(genotypes1)/2
    if len(genotypes2)/2 != n_indiv:
        print "genotypes should be of same length (exiting)"
        raise SystemExit
    gen1 = []
    gen2 = []
    for i in range(n_indiv):
        if genotypes1[2*i] in alleles1 and genotypes2[2*i] in alleles2:
            gen1.append(genotypes1[2*i])
            gen1.append(genotypes1[2*i+1])
            gen2.append(genotypes2[2*i])
            gen2.append(genotypes2[2*i+1])
    return (gen1,gen2)
    

# genotypes are lists: a11, a12, a21, a22, a31, a32, ...
# alleles are list of length 2
# alleles are letters
# output is a list of half the length, which is integers
def convert_dosage(genotypes,alleles):
    if len(genotypes)%2 != 0:
        print "genotypes should have length divisible by 2 (exiting)"
        raise SystemExit
    n_indiv = len(genotypes)/2
    dosage = []
    for i in range(n_indiv):
        dosage.append(int(genotypes[2*i]==alleles[0])+int(genotypes[2*i+1]==alleles[0]))
    return dosage

#x and y are numeric vectors        
def get_corr(x,y):
   if len(x)!=len(y):
       print "error: lengths of vectors don't match in get_corr"
   n = len(x)
   xSum = 0.0
   xxSum = 0.0
   ySum = 0.0
   yySum = 0.0
   xySum = 0.0
   for j in range(n):
      xVal = x[j]
      yVal = y[j]
      xSum +=  xVal;
      xxSum += xVal * xVal;
      ySum += yVal;
      yySum += yVal * yVal;
      xySum += xVal * yVal;
        
   cov = xySum - (xSum * ySum) / float(n);
   xVar = xxSum - (xSum * xSum) / float(n);
   yVar = yySum - (ySum * ySum) / float(n);
   den = sqrt(xVar*yVar);
   if den>0:
       return cov/den;
   else:
       return 0
   

# genotypes are lists: a11, a12, a21, a22, a31, a32, ...
# alleles are list of length 2
# alleles are letters
def calc_r(genotypes1,genotypes2,alleles1,alleles2):
   (reduced_gen1,reduced_gen2) = remove_missing(genotypes1,genotypes2,alleles1,alleles2) 
   if len(reduced_gen1)<0.7*len(genotypes1):
      return 0.0 # too much missing data to compute r
   g1d = convert_dosage(reduced_gen1,alleles1)
   g2d = convert_dosage(reduced_gen2,alleles2)
   #   corr = r.cor(g1d,g2d)
   corr = get_corr(g1d,g2d)
   return corr

# go through pairs of markers within window_length, and add tallys if
# the LD is definitely in same direction or not
def compareLD(markerInfoByPos,r_threshold):
    positions = markerInfoByPos.keys()
    positions.sort()
    # in markerInfoByPos, put in LD_comp which is dictionary
    # key is filenbr, values is list with nbr comp with r in right direction
    # and nbr comp with r in wrong direction
    window_length = 100
    for i in range(len(positions)):
        item_i = markerInfoByPos[positions[i]]
        files_i = item_i.get_goodfiles()
        if len(files_i) < 2 or not 0 in files_i:
            continue
        for j in range(i+1,min(i+window_length+1,len(positions))):
            item_j = markerInfoByPos[positions[j]]
            files_j = item_j.get_goodfiles()
            if len(files_j) < 2 or not 0 in files_j:
                continue
            files_with_both = []
            for filenbr in files_i:
                if filenbr in files_j:
                    files_with_both.append(filenbr)
            if len(files_with_both)<2:
                continue
            for filenbr in files_with_both:
                genotypes1 = item_i.get_genotypes(filenbr)
                genotypes2 = item_j.get_genotypes(filenbr)
                alleles1 = item_i.get_refAlleles()
                alleles2 = item_j.get_refAlleles()
                marker_LD = calc_r(genotypes1,genotypes2,alleles1,alleles2)
                if filenbr == 0:
                    ref_LD = marker_LD
                    if abs(ref_LD) < r_threshold:
                        break
                else:
                    if abs(marker_LD) < r_threshold:
                        continue
                    diff_direction = (ref_LD > 0 and marker_LD <0) or (ref_LD < 0 and marker_LD > 0)
                    already_switched1 = item_i.needs_switch(filenbr)
                    already_switched2 = item_j.needs_switch(filenbr)
                    if already_switched1:
                        diff_direction = not diff_direction
                    if already_switched2:
                        diff_direction = not diff_direction
                    if diff_direction:
                        item_i.add_bad_LDcomp(filenbr)
                        item_j.add_bad_LDcomp(filenbr)
                    else:
                        item_i.add_good_LDcomp(filenbr)
                        item_j.add_good_LDcomp(filenbr)
                        
                    
            
        
def checkLD(markerInfoByPos,r_threshold,log_file,filenames):
    compareLD(markerInfoByPos,r_threshold)
    for marker in markerInfoByPos.values():
        LDcomp = marker.get_LDcomp()
        for filenbr in marker.LDcomp.keys():
            positive = marker.LDcomp[filenbr][0]
            negative = marker.LDcomp[filenbr][1]
            if negative >=2:
                if positive < 2 and marker.allows_switch(filenbr) and not marker.needs_switch(filenbr):
                    # make the switch
                    marker.set_switchNeeded(filenbr)
                    print >> log_file, marker.get_snpname(), "needs to be switched - discovered by LD"
                else:
                    print >> log_file, "inconsistent LD patterns",marker.get_snpname(),filenames[filenbr]
                    marker.set_badfile(filenbr)


