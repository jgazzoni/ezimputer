#!/bin/bash
# If you installed all the tools using our own scripts, this script will produce a
# prototype of a config file as long as you have the right system tools
# installed. perl, python, java, and sun grid engine (SGE) or portable Batch System PBS.
#
# To use this script, 
# bash make_tool_info.pl full_path_for_ezimputer_without_a_slash_at_the_end
#
if [ "$#" -eq 1 ]
then
EZIMPUTER=$1
PLINK="${EZIMPUTER}/EXTERNALTOOLS/PLINK/plink"
testp=`${EZIMPUTER}/EXTERNALTOOLS/STRUCTURE/console/source/structure_kernel_src/structure | grep -c 'Purcell'`
if [ $testp -eq 1 ] 
    then
    PLINK="${EZIMPUTER}/EXTERNALTOOLS/STRUCTURE/console/source/structure_kernel_src/structure"
fi
STRUCTURE="${EZIMPUTER}/EXTERNALTOOLS/STRUCTURE/console/structure"
STRUCTURE_PARAM="${EZIMPUTER}/EXTERNALTOOLS/STRUCTURE/console/extraparams"
SHAPEIT="${EZIMPUTER}/EXTERNALTOOLS/SHAPEIT/shapeit.v1.ESHG.linux.x86_64"
IMPUTE="${EZIMPUTER}/EXTERNALTOOLS/IMPUTE/impute_v2.3.0_x86_64_static/impute2"
CHECK_STRAND="${EZIMPUTER}/EXTERNALTOOLS/CHECK_STRAND/check_strands_16May11/check_strands.py"
GPROBS="${EZIMPUTER}/EXTERNALTOOLS/GPROBS/gprobsmetrics.jar"
echo "PLINK=${PLINK}"
echo "STRUCTURE=${STRUCTURE}"
echo "STRUCTURE_PARAM=${STRUCTURE_PARAM}"
echo "SHAPEIT=${SHAPEIT}"
echo "IMPUTE=${IMPUTE}"
echo "CHECK_STRAND=${CHECK_STRAND}"
echo "GPROBS=${GPROBS}"
PERL=`which perl`
echo "PERL=${PERL}"
PYTHON=`which python`
echo "PYTHON=${PYTHON}"
JAVA=`which java`
echo "JAVA=${JAVA}"
QSUB=`which qsub`
echo "QSUB=${QSUB}"
SH=`which bash`
echo "SH=${SH}"
else
    echo "usage:  make_tool_info.sh path_to_ezimputer_install_without_a_slash_at_the_end"
fi
