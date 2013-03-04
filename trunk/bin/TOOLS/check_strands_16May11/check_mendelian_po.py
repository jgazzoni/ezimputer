# check_mendelian_po.py

print "usage: python check_mendelian_po.py po.bgl new_po.bgl missing_code"

import sys

pofile = open(sys.argv[1])
outfile = open(sys.argv[2],"w")
missing_code = sys.argv[3]

def isConsistent(a1,a2,c,missing_code):
    return c == missing_code or a1 == missing_code or a2 == missing_code or c == a1 or c == a2

for line in pofile.xreadlines():
  elements = line.split()
  if elements[0] == "M":
    alleles = elements[2:]
    rs = elements[1]
    for j in range(0,len(alleles),4):
        b1 = isConsistent(alleles[j],alleles[j+1],alleles[j+2],missing_code) 
        b2 = isConsistent(alleles[j],alleles[j+1],alleles[j+3],missing_code)
        if not (b1 or b2):
          print "mendelian inconsistency at",rs,"p/o",j/4+1,":",alleles[j:(j+4)],"(setting all to missing)"
          for i in range(4):
            alleles[j+i] = missing_code
    print >> outfile, "M",rs,
    for a in alleles:
        print >> outfile,a,
    print >> outfile
  else:
      print >> outfile, line,

