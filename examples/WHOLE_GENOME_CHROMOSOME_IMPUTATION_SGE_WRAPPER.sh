#Set your ezimputer program directory
set -x

if [ "$#" -ne 2 ]
then
	echo "usage:  WHOLE_GENOME_CHROMOSOME_IMPUTATION_SGE_WRAPPER.sh <path_to_ezimputer_install> <path_to_process_dir>"
	exit 1
else
	export EZIMPUTER=$1
	export EXAMPLES=$2
	mkdir -p $EXAMPLES
fi
EZIMPUTER=`echo $EZIMPUTER|sed 's/\/$//g'`
EXAMPLES=`echo $EXAMPLES|sed 's/\/$//g'`
#export EZIMPUTER=/data5/bsi/RandD/Workflow/temp/hugues_test_shapeit/ezimputer/new_ref_ezimputer
#replace the path for example with your working directory
#export EXAMPLES=/data5/bsi/RandD/Workflow/temp/hugues_test_shapeit/ezimputer/new_ref_ezimputer/test1
#get the hapmap data
# Here you would replace this script with command to get your own data.
cd $EXAMPLES

wget http://hapmap.ncbi.nlm.nih.gov/downloads/genotypes/hapmap3_r3/plink_format/hapmap3_r3_b36_fwd.consensus.qc.poly.map.gz
wget http://hapmap.ncbi.nlm.nih.gov/downloads/genotypes/hapmap3_r3/plink_format/hapmap3_r3_b36_fwd.consensus.qc.poly.ped.gz

#Uncompress(gunzip) them and convert the plink files to plink transpose files (this may take ~1 hour)
gunzip hapmap3_*.gz

SH=`which sh`
if [ -x $SH ]
then
	echo "sh exists $SH"
else
   echo "SHELL SCRIPT SH either not exists or don't have the executable permissions"
   exit 1
fi

#download & prepare external tools
# Skip this if you have already installed the tools.. and set TOOLINFO to the path/name of your tool_info.config file
###$EZIMPUTER/install_tools.sh $EZIMPUTER
###make tool_info.config file
$SH $EZIMPUTER/make_tool_info.sh $EZIMPUTER > $EXAMPLES/tool_info.config
if [ $? -ne 0 ]
then
	echo "Some thing wrong with the script $EZIMPUTER/make_tool_info.sh. check for $EXAMPLES/tool_info.config!"
	exit 1
fi
export TOOLINFO=$EXAMPLES/tool_info.config


PERL=`grep 'PERL=' $TOOLINFO | cut -d '=' -f2`

#convert the plink file format to transpose
PLINK=`grep 'PLINK='  $TOOLINFO | cut -d '=' -f2 `

#Extract the top 50 samples 
cut -f1-6 -d ' ' $EXAMPLES/hapmap3_r3_b36_fwd.consensus.qc.poly.ped|head -50   > $EXAMPLES/hapmap3_r3_b36_fwd.consensus.qc.poly_50.keep 
$PLINK --file $EXAMPLES/hapmap3_r3_b36_fwd.consensus.qc.poly  --keep $EXAMPLES/hapmap3_r3_b36_fwd.consensus.qc.poly_50.keep --chr 22 --make-bed --out $EXAMPLES/hapmap3_r3_b36_fwd.consensus_subset50_chr22.qc.poly

#get imputataion reference
mkdir $EXAMPLES/impute_ref

$PERL  $EZIMPUTER/Get_impute_reference.pl  -OUT_REF_DIR  $EXAMPLES/impute_ref  -DOWNLOAD_LINK   http://mathgen.stats.ox.ac.uk/impute/ALL_1000G_phase1integrated_v3_impute.tgz 
#cp -R /data5/bsi/refdata/genetics/1000Genomes/downloaded_data/release/20110521/impute/ALL_1000G_phase1integrated_v3_impute/ $EXAMPLES/impute_ref 
if [ $? -ne 0 ]
then
	echo "Some thing wrong with the script $EZIMPUTER/Get_impute_reference.pl. Impute2 reference files not generated!"
	exit
fi

#preparing run config file for the Wrapper script
echo "INPUT_PLINK=$EXAMPLES/hapmap3_r3_b36_fwd.consensus_subset50_chr22.qc.poly"  > $EXAMPLES/Wrapper_run_info.config
echo "IMP2_OUT_DIR=$EXAMPLES/WHOLECHR"  >> $EXAMPLES/Wrapper_run_info.config
echo "MODULES_NEEDED=UPGRADE_BUILD,IMPUTE"  >> $EXAMPLES/Wrapper_run_info.config
echo "DBSNP_DOWNLOADLINK=ftp://ftp.ncbi.nlm.nih.gov/snp/organisms/human_9606/database/organism_data/b137_SNPChrPosOnRef.bcp.gz"  >> $EXAMPLES/Wrapper_run_info.config
echo "DBSNP_DIR=/data2/bsi/RandD/Arraybased_RND/Easy_imputer_test/DBDIR"  >> $EXAMPLES/Wrapper_run_info.config
echo "IMPUTE_REF=$EXAMPLES/impute_ref/ALL_1000G_phase1integrated_v3_impute"  >> $EXAMPLES/Wrapper_run_info.config
echo "IMPUTEREF_VERSION=ALL_1000G_phase1integrated_v3_impute"  >> $EXAMPLES/Wrapper_run_info.config
echo "BEAGLE_REF_DB=/data2/bsi/RandD/Arraybased_RND/Easy_imputer_test/DBDIR/BEAGLE/"  >> $EXAMPLES/Wrapper_run_info.config
echo "EMAIL=prodduturi.naresh@mayo.edu"  >> $EXAMPLES/Wrapper_run_info.config
echo "USERNAME=m081429"  >> $EXAMPLES/Wrapper_run_info.config
echo "DEAL_AMBIGUOUS=YES"  >> $EXAMPLES/Wrapper_run_info.config
echo "ENVR=MANUAL"  >> $EXAMPLES/Wrapper_run_info.config
perl  $EZIMPUTER/Wrapper.pl  -wrapper_config $EXAMPLES/Wrapper_run_info.config -tool_config $TOOLINFO