# modify_files.py

from combine_markers import *


def switch_alleles(lineinfo):
    import combine_markers
    for i in range(2,len(lineinfo)):
        lineinfo[i] = combine_markers.single_switch(lineinfo[i])

# read the input file, check status in marker_info, and output as appropriate
# input file and output file are bgl format
def modify(input_file,output_file,filenbr,markerInfoByRs,missing_code,log_file,filenames):
    input_file.seek(0)
    for line in input_file.xreadlines():
        lineinfo = line.split()
        if lineinfo[0]!='M':
            print >> output_file, line,
            continue
        rs = lineinfo[1]
        if not markerInfoByRs.has_key(rs):
            continue
        marker_item = markerInfoByRs[rs]
        if filenbr in marker_item.get_badfiles():
            continue
        lineinfo[1] = marker_item.get_snpname() # change snp name if it doesn't match reference
        if marker_item.needs_switch(filenbr):
            switch_alleles(lineinfo)
            print >> log_file, "switching",lineinfo[1],filenames[filenbr]
        print >> output_file, lineinfo[0],lineinfo[1],
        for x in lineinfo[2:]:
            if not isNucleotide(x):
                x = missing_code
            print >> output_file, x,
        print >> output_file
        
