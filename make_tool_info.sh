#!/bin/bash
# If you installed all the tools using our own scripts, this script will produce a
# prototype of a config file as long as you have the right system tools
# installed. perl, python, java, and sun grid engine (SGE) or portable Batch System PBS.
#
# To use this script, 
# bash make_tool_info.pl full_path_for_ezimputer
#
if [ "$#" -eq 1 ]
then
EZIMPUTER=$1
EZIMPUTER=`echo $EZIMPUTER|sed 's/\/$//g'`
PLINK="${EZIMPUTER}/PLINK/plink-1.07-x86_64/plink"
STRUCTURE="${EZIMPUTER}/STRUCTURE/console/structure"
STRUCTURE_PARAM="${EZIMPUTER}/STRUCTURE/console/extraparams"
SHAPEIT="${EZIMPUTER}/SHAPEIT/shapeit"
IMPUTE="${EZIMPUTER}/IMPUTE/impute_v2.3.0_x86_64_static/impute2"
CHECK_STRAND="${EZIMPUTER}/CHECK_STRAND/check_strands_16May11/check_strands.py"
GPROBS="${EZIMPUTER}/GPROBS/gprobsmetrics.jar"
PERL=`which perl`
PYTHON=`which python`
JAVA=`which java`
QSUB=`which qsub`
SH=`which bash`
#plink
if [[ !  -f $PLINK ]]
    then
    echo "no plink found $PLINK"
    exit 1	
fi
if [[ !  -x $PLINK ]]
    then
    echo "plink found but it is not executable $PLINK"
    exit 1
fi
#structure
if [[ !  -f $STRUCTURE ]]
    then
    echo "no structure found $STRUCTURE"
    exit 1	
fi
if [[ !  -x $STRUCTURE ]]
    then
    echo "structure found but it is not executable $STRUCTURE"
    exit 1
fi
#structure param
if [[ !  -f $STRUCTURE_PARAM ]]
    then
    echo "no structureparam found $STRUCTURE_PARAM"
    exit 1	
fi
#shapeit
if [[ !  -f $SHAPEIT ]]
    then
    echo "no shapeit found $SHAPEIT"
    exit 1	
fi
if [[ !  -x $SHAPEIT ]]
    then
    echo "shapeit found but it is not executable $SHAPEIT"
    exit 1
fi
#impute
if [[ !  -f $IMPUTE ]]
    then
    echo "no impute found $IMPUTE"
    exit 1	
fi
if [[ !  -x $IMPUTE ]]
    then
    echo "impute found but it is not executable $IMPUTE"
    exit 1
fi
#CHECK_STRAND
if [[ !  -f $CHECK_STRAND ]]
    then
    echo "no CHECK_STRAND found $CHECK_STRAND"
    exit 1	
fi
#if [[ !  -x $CHECK_STRAND ]]
#    then
#    echo "CHECK_STRAND found but it is not executable $CHECK_STRAND"
#    exit 1
#fi
#GPROBS
if [[ !  -f $GPROBS ]]
    then
    echo "no GPROBS found $GPROBS"
    exit 1	
fi

#PERL
if [[ !  -f $PERL ]]
    then
    echo "no PERL found $PERL"
    exit 1	
fi
if [[ !  -x $PERL ]]
    then
    echo "PERL found but it is not executable $PERL"
    exit 1
fi
#PYTHON
if [[ !  -f $PYTHON ]]
    then
    echo "no PYTHON found $PYTHON"
    exit 1	
fi

#JAVA
if [[ !  -f $JAVA ]]
    then
    echo "no JAVA found $JAVA"
    exit 1	
fi
if [[ !  -x $JAVA ]]
    then
    echo "JAVA found but it is not executable $JAVA"
    exit 1
fi
#SH
if [[ !  -f $SH ]]
    then
    echo "no SH found $SH"
    exit 1	
fi
if [[ !  -x $SH ]]
    then
    echo "SH found but it is not executable $SH"
    exit 1
fi
echo "PLINK=${PLINK}"
echo "STRUCTURE=${STRUCTURE}"
echo "STRUCTURE_PARAM=${STRUCTURE_PARAM}"
echo "SHAPEIT=${SHAPEIT}"
echo "IMPUTE=${IMPUTE}"
echo "CHECK_STRAND=${CHECK_STRAND}"
echo "GPROBS=${GPROBS}"
echo "PERL=${PERL}"
echo "PYTHON=${PYTHON}"
echo "JAVA=${JAVA}"
echo "QSUB=${QSUB}"
echo "SH=${SH}"
else
    echo "usage:  make_tool_info.sh <path_to_install_directory>"
fi
