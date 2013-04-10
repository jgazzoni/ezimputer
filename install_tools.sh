#!/bin/bash
#
# This script will install all anciliary tools for ezimputer
# usage: install_tools.sh path_to_ezimputer_install_without_a_slash_at_the_end
#
#DETAILED DESCRIPTION TO DOWNLOAD THE TOOLS

if [ "$#" -eq 1 ]
then


export EZIMPUTER=$1
#Create main tools directory
mkdir $EZIMPUTER/EXTERNALTOOLS
#Change directory
cd  $EZIMPUTER/EXTERNALTOOLS
#PLINK 
#Create main plink directory
mkdir $EZIMPUTER/EXTERNALTOOLS/PLINK
#Change to plink main directory
cd $EZIMPUTER/EXTERNALTOOLS/PLINK
#Download the plink package
wget http://pngu.mgh.harvard.edu/~purcell/plink/dist/plink-1.07-x86_64.zip
#Uncompresszip files
unzip plink-1.07-x86_64.zip
#The plink binary is now in $EZIMPUTER/EXTERNALTOOLS/PLINK/plink-1.07-x86_64/plink
# when you enter the path in the too info file, you must replace the value of
# $EZIMPUTER with the actual path, e.g.
testp=`$EZIMPUTER/EXTERNALTOOLS/PLINK/plink-1.07-x86_64/plink | grep -c 'Purcell'`
if [ $testp -eq 0 ]
    then
    echo "Error during plink installation"
    $EZIMPUTER/EXTERNALTOOLS/PLINK/plink-1.07-x86_64/plink
fi


#STRUCTURE
#Create main STRUCTURE directory
mkdir $EZIMPUTER/EXTERNALTOOLS/STRUCTURE
#Change to STRUCTURE directory
cd $EZIMPUTER/EXTERNALTOOLS/STRUCTURE
#Download the STRUCTURE tool
wget http://pritch.bsd.uchicago.edu/structure_software/release_versions/v2.3.4/release/structure_linux_console.tar.gz
tar -zxvf structure_linux_console.tar.gz
cd console
#test the structure executable with absolute path (change the permission if necessary)


test=`$EZIMPUTER/EXTERNALTOOLS/STRUCTURE/console/structure | grep -c 'STRUCTURE'`
if [ $test -eq 0 ] 
    then 
    testlibc=`$EZIMPUTER/EXTERNALTOOLS/STRUCTURE/console/structure | grep -c 'libc'`
    if [ $testlibc -eq 1 ] 
    then
#If you the program is giving the error ./lib/libc.so.6: version `GLIBC_2.7' not found.. You need to #download the source and recompile the program
	mkdir $EZIMPUTER/EXTERNALTOOLS/STRUCTURE/console/source/
	cd $EZIMPUTER/EXTERNALTOOLS/STRUCTURE/console/source/
#Get the source package
	wget http://pritch.bsd.uchicago.edu/structure_software/release_versions/v2.3.4/structure_kernel_source.tar.gz
#uncompress the  package
	tar -zxvf structure_kernel_source.tar.gz
	cd structure_kernel_src/
#compile
	make
#Test the new executable
	testnew=`$EZIMPUTER/EXTERNALTOOLS/STRUCTURE/console/source/structure_kernel_src/structure | grep -c 'STRUCTURE'`
	if [ $testlibc -eq 0 ] 
	then
	    echo "installation of STRUCTURE failed after compilation\n";
	fi
    else 
	    echo "installation of STRUCTURE failed for unknown reason, please try manually\n";
    fi
fi

#SHAPEIT
#Create main SHAPEIT directory
mkdir $EZIMPUTER/EXTERNALTOOLS/SHAPEIT
#Change to SHAPEIT directory
cd $EZIMPUTER/EXTERNALTOOLS/SHAPEIT
#Download SHAPEIT tool package
wget http://www.shapeit.fr/script/get.php?id=16
#Untar the downloaded package
tar -zxvf shapeit.v1.ESHG.linux.x64.tar.gz
#Try SHAPEIT
stest=` ($EZIMPUTER/EXTERNALTOOLS/SHAPEIT/shapeit.v1.ESHG.linux.x86_64 --h  2>&1 )| grep -c 'Phaser'`
#You should be able to see
#Phaser options:
#  --help                                Produce licence message
#  --licence                             Produce licence message
#  -v [ --version ]                      Produce version details
#  -L [ --output-log ] arg (=shapeit_05032013_14h55m40s_b4340e74-e467-4ed8-9bc9-4dee02807b9a.log)
#                                        Log file
#  --exclude-snp arg                     File containing all the positions of
#                                        the SNPs to exclude in input files
#  --include-snp arg                     File containing all the positions of
#.(and many more lines)

if [ $stest -eq 0 ]
    then
    echo "Unable to install shapeit"
    $EZIMPUTER/EXTERNALTOOLS/SHAPEIT/shapeit.v1.ESHG.linux.x86_64 --h
fi


#IMPUTE
#Create main IMPUTE directory
mkdir $EZIMPUTER/EXTERNALTOOLS/IMPUTE
#Change to IMPUTE directory
cd $EZIMPUTER/EXTERNALTOOLS/IMPUTE
#Download IMPUTE tool package
wget http://mathgen.stats.ox.ac.uk/impute/impute_v2.3.0_x86_64_static.tgz
#Untar the downloaded package
tar -zxvf impute_v2.3.0_x86_64_static.tgz
#change directory 
cd impute_v2.3.0_x86_64_static
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
    ./impute2
fi



#CHECK_STRAND
#Create main CHECK_STRAND directory
mkdir $EZIMPUTER/EXTERNALTOOLS/CHECK_STRAND
#Change to CHECK_STRAND directory
cd $EZIMPUTER/EXTERNALTOOLS/CHECK_STRAND
#Download CHECK_STRAND package
wget http://faculty.washington.edu/sguy/beagle/strand_switching/check_strands_16May11.tar.gz
#uncompress the package
tar -zxvf check_strands_16May11.tar.gz
#change directory
cd check_strands_16May11
# test program
#python check_strands.py
# You should be able to see
#usage: python check_strands.py infileprefixes outfileprefix
#outfiles: check_strands.py.markers check_strands.py.log
#completed combining marker files
#done checking frequencies

#(1)GPROBS
#Create main GPROBS directory
mkdir $EZIMPUTER/EXTERNALTOOLS/GPROBS
#Change to GPROBS directory
cd $EZIMPUTER/EXTERNALTOOLS/GPROBS
#Download GPROBS package
wget http://faculty.washington.edu/browning/beagle_utilities/gprobsmetrics.jar
#Once you are done with downloading next step is to create the tool info config file (here). 


else

echo "usage: install_tools.sh path_to_ezimputer_install_without_trailing_slash"
fi