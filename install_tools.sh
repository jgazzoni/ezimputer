#!/bin/bash
#
# This script will install all anciliary tools for ezimputer
# usage: install_tools.sh path_to_install_directory
#
#DETAILED DESCRIPTION TO DOWNLOAD THE TOOLS

if [ "$#" -eq 1 ]
then


export EZIMPUTER=$1
EZIMPUTER=`echo $EZIMPUTER|sed 's/\/$//g'`
echo "INSTALL DIRECTORY SPECIFIED: $EZIMPUTER"

#Create main tools directory
mkdir -p $EZIMPUTER
mkdir $EZIMPUTER/LOG
#Change directory
cd $EZIMPUTER

tools_installed=""
tools_installed_ind=1

#CHECK_STRAND
#Create main CHECK_STRAND directory
mkdir $EZIMPUTER/CHECK_STRAND
#Change to CHECK_STRAND directory
cd $EZIMPUTER/CHECK_STRAND
#Download CHECK_STRAND package
wget http://faculty.washington.edu/sguy/beagle/strand_switching/check_strands_16May11.tar.gz
#uncompress the package
tar -zxvf check_strands_16May11.tar.gz
#change directory
cd check_strands_16May11
chmod +xr $EZIMPUTER/CHECK_STRAND/check_strands_16May11/check_strands.py
python $EZIMPUTER/CHECK_STRAND/check_strands_16May11/check_strands.py > $EZIMPUTER/LOG/CHECK_STRAND.log 2>&1 
python $EZIMPUTER/CHECK_STRAND/check_strands_16May11/check_strands.py
if [ $? -ne 0 ]
    then
    echo "Unable to download beagle utils or python is not set to the path"
    tools_installed_ind=0
	tools_installed=$tools_installed" CHECK_STRAND_BEAGLE_UTILS"
fi


#PLINK 
#Create main plink directory
mkdir $EZIMPUTER/PLINK
#Change to plink main directory
cd $EZIMPUTER/PLINK
#Download the plink package
wget http://pngu.mgh.harvard.edu/~purcell/plink/dist/plink-1.07-x86_64.zip
#Uncompresszip files
unzip plink-1.07-x86_64.zip
#The plink binary is now in $EZIMPUTER/PLINK/plink-1.07-x86_64/plink
# when you enter the path in the too info file, you must replace the value of
# $EZIMPUTER with the actual path, e.g.
chmod +xr $EZIMPUTER/PLINK/plink-1.07-x86_64/plink
$EZIMPUTER/PLINK/plink-1.07-x86_64/plink > $EZIMPUTER/LOG/PLINK.log 2>&1 
testp=`$EZIMPUTER/PLINK/plink-1.07-x86_64/plink | grep -c 'Purcell'`
if [ $testp -eq 0 ]
    then
    echo "Error during plink installation"
    tools_installed_ind=0
	tools_installed=$tools_installed" PLINK"
fi


#STRUCTURE
#Create main STRUCTURE directory
mkdir $EZIMPUTER/STRUCTURE
#Change to STRUCTURE directory
cd $EZIMPUTER/STRUCTURE
#Download the STRUCTURE tool
wget http://pritchardlab.stanford.edu/structure_software/release_versions/v2.3.4/release/structure_linux_console.tar.gz

#uncompress the  package
tar -zxvf structure_linux_console.tar.gz
cd console/
chmod +xr $EZIMPUTER/STRUCTURE/console/structure
#Test the new executable
echo "$EZIMPUTER/STRUCTURE/console/structure"
$EZIMPUTER/STRUCTURE/console/structure > $EZIMPUTER/LOG/STRUCTURE.log 2>&1 
testnew=`$EZIMPUTER/STRUCTURE/console/structure | grep -c 'STRUCTURE'`
if [ $testnew -eq 0 ] 
then
	echo "installation of STRUCTURE failed after compilation\n";
	tools_installed_ind=0
	tools_installed=$tools_installed" STRUCTURE"
fi



#IMPUTE
#Create main IMPUTE directory
mkdir $EZIMPUTER/IMPUTE
#Change to IMPUTE directory
cd $EZIMPUTER/IMPUTE
#Download IMPUTE tool package
wget http://mathgen.stats.ox.ac.uk/impute/impute_v2.3.0_x86_64_static.tgz
#Untar the downloaded package
tar -zxvf impute_v2.3.0_x86_64_static.tgz
#change directory 
cd impute_v2.3.0_x86_64_static
chmod +xr impute2
./impute2 > $EZIMPUTER/LOG/IMPUTE.log 2>&1 
#Try Impute
itest=`./impute2 | grep -c 'IMPUTE'`
#You should be able to see
#======================
# IMPUTE version 2.2.2
#======================
#
#Copyright 2008 Bryan Howie, Peter Donnelly, and Jonathan Marchini
#Please see the LICENCE file included with this program for conditions of use.
#
#The seed for the random number generator is 1997316289.
#
#Command-line input: impute2
#
#ERROR: You must specify a valid interval for imputation using the -int argument.

if [ $itest -eq 0 ]
    then
    echo "Error during the impute installation"
    tools_installed_ind=0
	tools_installed=$tools_installed" IMPUTE"
fi






#(1)GPROBS
#Create main GPROBS directory
mkdir $EZIMPUTER/GPROBS
#Change to GPROBS directory
cd $EZIMPUTER/GPROBS
#Download GPROBS package
wget http://faculty.washington.edu/browning/beagle_utilities/gprobsmetrics.jar
chmod +xr $EZIMPUTER/GPROBS/gprobsmetrics.jar
java -jar $EZIMPUTER/GPROBS/gprobsmetrics.jar  -h >$EZIMPUTER/LOG/GPROBS.log 2>&1 
java -jar $EZIMPUTER/GPROBS/gprobsmetrics.jar  -h
if [ $? -ne 0 ]
    then
    echo "Unable to download gprobs or java is not set to the path"
    tools_installed_ind=0
	tools_installed=$tools_installed" GPROBS"
fi



#SHAPEIT
#Create main SHAPEIT directory
mkdir $EZIMPUTER/SHAPEIT
#Change to SHAPEIT directory
cd $EZIMPUTER/SHAPEIT
#Download SHAPEIT tool package
timeout 20 wget  https://mathgen.stats.ox.ac.uk/genetics_software/shapeit/shapeit.v2.r778.RHELS_5.4.static.tar.gz
if [ $? -eq 124 ]
    then
    echo "timeout occured while downloading shapeit tool, so copying the tool from local source"
    cp /data5/bsi/bioinf_int/s106381.borawork/naresh_scripts/PAPER/EasyImputer_v2/bin/TOOLS/SHAPEIT2/shapeit.v2.r727.linux.x64.tar.gz .
	
fi


#Untar the downloaded package
 tar -zxvf shapeit.*.tar.gz
#Try SHAPEIT
chmod +xr $EZIMPUTER/SHAPEIT/shapeit
 $EZIMPUTER/SHAPEIT/shapeit >$EZIMPUTER/LOG/SHAPEIT.log 2>&1 
$EZIMPUTER/SHAPEIT/shapeit

if [ $? -eq 0 ]
    then
    echo "Unable to install shapeit"
    tools_installed_ind=0
	tools_installed=$tools_installed" SHAPEIT"
fi

if [ $tools_installed_ind -eq 0 ]
then
	echo "Following tools not installed properly.Check the LOG directory in the install directory for more information"
	echo $tools_installed
fi
chmod -R 755 $EZIMPUTER/
else

echo "usage: install_tools.sh <path_to_install_directory>"
fi

#Once you are done with downloading next step is to create the tool info config file (here). 
