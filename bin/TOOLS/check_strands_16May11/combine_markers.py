# combine_markers.py

# set up object structure for markers, and perform some basic checks

from marker import *

# function to check whether a character value is A/C/T/G
def isNucleotide(x):
    return x in ('A','C','T','G')

# switch as single allele A<->T, C<->G
def single_switch(allele):
    if allele == "A":
        return "T"
    if allele == "T":
        return "A"
    if allele == "C":
        return "G"
    if allele == "G":
        return "C"
    return "-"

# alleles is a list
# switch A<->T, C<->G
# but if alleles = AT or CG return 0
def double_switch(alleles):
    if ("A" in alleles and "T" in alleles) or ("C" in alleles and "G" in alleles):
        return 0
    alleles[0] = single_switch(alleles[0])
    alleles[1] = single_switch(alleles[1])
    return 1

# check for more than 2 alleles, and construct reference alleles
def refAlleles(marker_item,log_file):
     # first look through to see if there are more than 2 alleles
     alleleList = marker_item.get_alleleList()
     alleles = []
     for alleleTriple in alleleList:
         alleles.append(alleleTriple[1])
         alleles.append(alleleTriple[2])
     i = 0
     while i<len(alleles):
         if not isNucleotide(alleles[i]):
             del alleles[i]
         elif i>0 and (alleles[i] in alleles[0:i]):
             del alleles[i]
         else:
             i += 1
     if len(alleles)>2:
         # return two alleles that are both seen in the same file, if possible
         # using the first such file in the list
         for alleleTriple in alleleList:
             if(isNucleotide(alleleTriple[1]) and isNucleotide(alleleTriple[2])):
                 ref = [alleleTriple[1],alleleTriple[2]]
                 if not alleles[0] in ref:
                     double_switch(ref)
                 return ref
     if len(alleles)==0:
         print >> log_file, "no valid alleles at marker position", marker_item.get_snpname(),"(removing)"
         marker_item.set_all_bad()         
         alleles = ["-","-"]
     if len(alleles)==1:
         alleles.append("-")
     return (alleles[0],alleles[1])


# both ref and alleles are lists of length 2
def consistent_alleles(alleles,ref):
    if isNucleotide(alleles[0]):
        if not alleles[0] in ref:
            return 0
    if isNucleotide(alleles[1]):
        if not alleles[1] in ref:
            return 0
    return 1


# returns tuple with needs,allows,bad
# bad means that there will be inconsistency with or without a switch
def needs_switch(alleleTriple,ref):
    alleles = [alleleTriple[1],alleleTriple[2]]
    if consistent_alleles(alleles,ref):
        needs = 0
    else:
        needs = 1
    double_switch(alleles)
    if consistent_alleles(alleles,ref):
        allows = 1
    else:
        allows = 0
    if needs and not allows:
        bad = 1
    else:
        bad = 0
    return (needs,allows,bad)
    

# checks for possible/required switches
def check_switch_needed(marker_item,log_file,filenames):
    ref = marker_item.get_refAlleles()
    for alleleTriple in marker_item.get_alleleList():
        filenbr = alleleTriple[0]
        (needs,allows,bad) = needs_switch(alleleTriple,ref)
        if bad:
            print >> log_file, "inconsistent alleles at rs", marker_item.get_snpname(),filenames[filenbr]
            marker_item.set_badfile(filenbr)
        if needs:
            marker_item.set_switchNeeded(filenbr)
        elif allows:
            marker_item.set_switchAllowed(filenbr)
           
    
     

# set up the combined markers info
# returns a dictionary
# key is position
# value is a dictionary with snpname, alleles, refAlleles
# alleles is a list with up to one tuple per file.  tuple is file#, allele1, allele2
# refAlleles is a tuple with allele1, allele2
def combineMarkers(nfiles,markerfiles,log_file,max_base_change,filenames):

 mydict = {}
 mydictbyrs = {}

 for i in range(nfiles):
     prev_pos = -1
     prev_prev_pos = -1
     for line in markerfiles[i].xreadlines():
         rs, pos, a1, a2 = line.split()
         pos = long(pos)
         badfile = 0
         if mydictbyrs.has_key(rs):
             altpos = mydictbyrs[rs].get_pos()
             if altpos != pos:
               if abs(altpos-pos) > max_base_change :
                 print >> log_file, "position of marker",rs,"is more than",max_base_change,"bases away from reference in file",filenames[i]
                 mydict[altpos].add_alleles(i,a1,a2)
                 mydict[altpos].set_badfile(i)
                 continue
               else:
                 print >> log_file, "changing position of",rs,"from",pos,"to",altpos,"in file",filenames[i]
                 pos = altpos
         big_dist = 500000
         if abs(pos-prev_pos)>=big_dist:
             print >> log_file, "WARNING: distance between markers is",pos-prev_pos,"at",rs,filenames[i],"suggesting a possible problem with marker order."
         if pos < prev_pos and abs(pos-prev_pos)<big_dist:
             if pos < prev_prev_pos:
                print >> log_file, "markers out of order, removing",rs
                mydict[pos].set_all_bad()
             else: # pos > prev_prev_pos
                bad_rs = mydict[prev_pos].get_snpname()
                print >> log_file, "markers out of order, removing",bad_rs
                mydict[prev_pos].set_all_bad()
         prev_prev_pos = prev_pos
         prev_pos = pos
         if mydict.has_key(pos):
             if mydict[pos].get_snpname() != rs:
                 print >> log_file, "more than one marker name at position", pos, mydict[pos].get_snpname(), rs, filenames[i]
                 mydict[pos].add_altname(rs)
         else:
             mydict[pos] = Marker(pos, rs)
         mydict[pos].add_alleles(i,a1,a2)
         if not mydictbyrs.has_key(rs):
             mydictbyrs[rs] = mydict[pos]

 for marker_item in mydict.values():
     r1,r2 = refAlleles(marker_item,log_file)
     marker_item.set_refAlleles(r1,r2)
     check_switch_needed(marker_item,log_file,filenames)

 print "completed combining marker files"
 
 return mydict, mydictbyrs
# done with basic checks
