#sh should be in the path to execute this script
#This script will install all anciliary tools for ezimputer and run all the example scripts for you
set -x
if [ "$#" -ne 2 ]
then
	echo "usage:sh  RUN_ALL_EXAMPLES.csh <path_to_ezimputer_install> <path_to_ezimputer_example_scripts>"
	SCRIPT=$(readlink -f "$0")
	EXAMPLES_SCRIPTS_DIR=`dirname $SCRIPT`
	EZIMPUTER=`echo $EXAMPLES_SCRIPTS_DIR|rev|tr '/' " "|cut -f2- -d ' '|rev|tr " " '/'`
	echo "If you just downloaded the tool and did not move any directory then just execute"
	echo "sh $EXAMPLES_SCRIPTS_DIR/RUN_ALL_EXAMPLES.csh  $EZIMPUTER $EXAMPLES_SCRIPTS_DIR"
	exit 1
else
	export EZIMPUTER=$1
	export EXAMPLES_SCRIPTS_DIR=$2
fi

SH=`which sh`
if [ -x $SH ]
then
	echo "sh exists $SH"
else
   echo "SHELL SCRIPT SH either not exists or don't have the executable permissions"
   exit 1
fi
echo " "
echo " "
echo " "
echo " "

#installing the tools
if [ -x "$EZIMPUTER/install_tools.sh" ]
then
	echo "tools will be executed in the dir $EZIMPUTER"
	$SH $EZIMPUTER/install_tools.sh $EZIMPUTER
else
   echo "script $EZIMPUTER/install_tools.sh either not exists or don't have the executable permissions"
   exit 1
fi

echo " "
echo " "
echo " "
echo " "

#running the WHOLECHROMSOME EXAMPLE
echo "running the whole chromosome example in the directory  $EZIMPUTER/test "
$SH $EXAMPLES_SCRIPTS_DIR/WHOLE_GENOME_CHROMOSOME_IMPUTATION_SGE_WRAPPER.sh  $EZIMPUTER $EZIMPUTER/test 
echo " "
echo " "
echo " "
echo " "

#running the SMALL REGION IMPUTATION EXAMPLE
echo "running the small region example in the directory  $EZIMPUTER/test "
$SH $EXAMPLES_SCRIPTS_DIR/SMALL_REGION_IMPUTATION_SGE_WRAPPER.sh   $EZIMPUTER $EZIMPUTER/test 
echo " "
echo " "
echo " "
echo " "

#running the SINGLE SAMPLE EXAMPLE
echo "running the single sample example in the directory  $EZIMPUTER/test "
$SH $EXAMPLES_SCRIPTS_DIR/SINGLE_SAMPLE_IMPUTATION_SGE_WRAPPER.sh   $EZIMPUTER $EZIMPUTER/test 
