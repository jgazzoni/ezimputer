# read_data.py
# read in bgl format data and store for future use
from marker import *




def readData(bglfiles,markerInfoByRs,log_file):
 for filenbr in range(len(bglfiles)):
  for line in bglfiles[filenbr].xreadlines():
    lineinfo = line.split()
    if lineinfo[0]!='M':
        continue
    rs = lineinfo[1]
    if not markerInfoByRs.has_key(rs):
        #print >> log_file, "marker file",filenbr,"did not contain info on snp",rs
        continue
    marker_item = markerInfoByRs[rs]
    alleles = marker_item.get_alleleList()
    for j in range(len(alleles)):
        if alleles[j][0] == filenbr:
            alleles = alleles[j][1:3]
            break
    else:
        #if not filenbr in marker_item.get_badfiles():
           #print >> log_file, "marker file",filenbr,"did not contain info on alleles at",rs
        continue

    if len(marker_item.get_goodfiles())>1:
        # save genotypes for future use
        marker_item.add_genotypes(filenbr,lineinfo[2:])

 
 # don't need to return anything, because markerInfoByRs was passed by reference
