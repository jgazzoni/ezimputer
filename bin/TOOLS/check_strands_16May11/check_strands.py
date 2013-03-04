# check strands, and create a combined marker file
# assumes anything that is not ACTG is a missing value

print "usage: python check_strands.py infileprefixes outfileprefix"

diff_prop_threshold = 0.2
r_threshold = 0.3
max_base_change = 100
missing_code = "0"

import sys
import string
import os

# open files and read in arguments
nfiles = len(sys.argv)-2
bglfiles = []
markerfiles = []
filenames = []
for i in range(nfiles):
    filenames.append(sys.argv[1+i])
    bglfiles.append(open(sys.argv[1+i]+".bgl","r"))
    print "bgl file", i, sys.argv[1+i]+".bgl"
    markerfiles.append(open(sys.argv[1+i]+".markers","r"))
outfileLog = open(sys.argv[1+nfiles]+".log","w")
outfileMarkers = open(sys.argv[1+nfiles]+".markers","w")
print "outfiles:", sys.argv[1+nfiles]+".markers", sys.argv[1+nfiles]+".log",
outbglfiles = []
for i in range(nfiles):
    filename = sys.argv[1+i]+"_mod.bgl"
    print filename,
    outbglfiles.append(open(filename,"w"))
print
    


# combine markers and check for mismatched allele names and mismatched marker names
import combine_markers
markerInfoByPos,markerInfoByRs = combine_markers.combineMarkers(nfiles,markerfiles,outfileLog,max_base_change,filenames)

import read_data
read_data.readData(bglfiles,markerInfoByRs,outfileLog)       

import check_freq
check_freq.checkFreq(markerInfoByRs,diff_prop_threshold,outfileLog,filenames)

import check_LD
check_LD.checkLD(markerInfoByPos,r_threshold,outfileLog,filenames)

# print combined marker file
positions = markerInfoByPos.keys()
positions.sort()
for pos in positions:
    item = markerInfoByPos[pos]
    if len(item.get_goodfiles())>0:
         print >> outfileMarkers, item.get_snpname(), pos, item.get_refAlleles()[0], item.get_refAlleles()[1]

# print modified bgl files
import modify_files
for i in range(nfiles):
    modify_files.modify(bglfiles[i],outbglfiles[i],i,markerInfoByRs,missing_code,outfileLog, filenames)


for file in bglfiles:
    file.close()
for file in markerfiles:
    file.close()
for file in outbglfiles:
    file.close()
outfileLog.close()
outfileMarkers.close()

print "done"
