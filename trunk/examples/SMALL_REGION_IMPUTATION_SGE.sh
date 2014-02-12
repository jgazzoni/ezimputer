# This assumes you already created a tool_info.config file in the main directory where you installed the tools.
set -x
export EZIMPUTER=/data5/bsi/RandD/Workflow/temp/hugues_test_shapeit/ezimputer/new_ref_ezimputer
#replace the path for example with your working directory
export EXAMPLES=/data5/bsi/RandD/Workflow/temp/hugues_test_shapeit/ezimputer/new_ref_ezimputer/test

###make tool_info.config file
$EZIMPUTER/make_tool_info.sh $EZIMPUTER > $EXAMPLES/tool_info.config

export TOOLINFO=$EXAMPLES/tool_info.config

PERL=`grep 'PERL=' $TOOLINFO | cut -d '=' -f2`


#First you need to run the WHOLE_GENOME_IMPUTATION.sh to generate the WHOLE_GENOME PLINK dataset
#unzip the ted file
cd $EXAMPLES



gunzip $EXAMPLES/processed_input.tped.gz
#extracting smalle region from whole genome
# Before running this script, you must run the whole genome workflow example up to the QC Step to generate the fwdStrandResults_input file
#convert the plink file format to transpose
PLINK=`grep 'PLINK='  $TOOLINFO | cut -d '=' -f2 `

$PLINK --tfile $EXAMPLES/processed_input --chr 22 --from-kb 43500 --to-kb 46000 --transpose --recode --out $EXAMPLES/small_region_fwdStrandResults_input
if [ $? -ne 0 ]
then
	echo "Some thing wrong with plink command.Plink Output fileset $EXAMPLES/chr22_hapmap3_r3_b36_fwd.consensus.qc.poly_build37 not generated!"
	exit
else
#compress the tped file
	gzip $EXAMPLES/small_region_fwdStrandResults_input.tped
fi

#create the config file
#preparing run config file for the Impute
echo "TPED=${EXAMPLES}/small_region_fwdStrandResults_input.tped.gz"  > $EXAMPLES/Small_region_impute_run_info.config
echo "TFAM=${EXAMPLES}/small_region_fwdStrandResults_input.tfam"  >> $EXAMPLES/Small_region_impute_run_info.config
echo "FORWARDSTRAND_IND=${EXAMPLES}/fwdStrandResults_input.ind"  >> $EXAMPLES/Small_region_impute_run_info.config
echo "TEMP_FOLDER=${EXAMPLES}/temp"  >> $EXAMPLES/Small_region_impute_run_info.config
echo "IMPUTE_REF=${EXAMPLES}/impute_ref/ALL_1000G_phase1integrated_v3_impute"  >> $EXAMPLES/Small_region_impute_run_info.config
echo "IMPUTE_WINDOW=5000000"  >> $EXAMPLES/Small_region_impute_run_info.config
echo "IMPUTE_EDGE=125"  >> $EXAMPLES/Small_region_impute_run_info.config
echo "HAPS=NA"  >> $EXAMPLES/Small_region_impute_run_info.config
echo "EMAIL=******.****@**.com"  >> $EXAMPLES/Small_region_impute_run_info.config
#echo "SGE_SHAPEIT_MEM=10G"  >> $EXAMPLES/Small_region_impute_run_info.config
#echo "SGE_SHAPEIT_QUEUE=7-days"  >> $EXAMPLES/Small_region_impute_run_info.config
#echo "SGE_IMPUTE_MEM=10G"  >> $EXAMPLES/Small_region_impute_run_info.config
#echo "SGE_IMPUTE_QUEUE=1-day"  >> $EXAMPLES/Small_region_impute_run_info.config
echo "LOCALTEMP_SHAPEIT=4G"  >> $EXAMPLES/Small_region_impute_run_info.config
echo "LOCALTEMP_IMPUTE=1G"  >> $EXAMPLES/Small_region_impute_run_info.config
echo "INNER_DIR=SMALL_REGION"  >> $EXAMPLES/Small_region_impute_run_info.config
echo "RESTART=NO"  >> $EXAMPLES/Small_region_impute_run_info.config
echo "USERNAME=username"  >> $EXAMPLES/Small_region_impute_run_info.config
echo "SHAPEITONLY=NO"  >> $EXAMPLES/Small_region_impute_run_info.config
echo "LOCALTEMP=${EXAMPLES}/temp/LOCALTEMP"  >> $EXAMPLES/Small_region_impute_run_info.config
echo 'SHAPEIT_EXTRA_PARAM="--seed 123456789 --states 100 --thread 4"'  >> $EXAMPLES/Small_region_impute_run_info.config
echo "CHR_START_INPUT=YES"  >> $EXAMPLES/Small_region_impute_run_info.config
echo "SMALL_REGION_EXTN_START=2000000"  >> $EXAMPLES/Small_region_impute_run_info.config
echo "SMALL_REGION_EXTN_STOP=2000000"  >> $EXAMPLES/Small_region_impute_run_info.config
echo "WINDOW_CUTOFF_NUM_MARKERS=200"  >> $EXAMPLES/Small_region_impute_run_info.config
echo "EDGE_CUTOFF_NUM_MARKERS=50"  >> $EXAMPLES/Small_region_impute_run_info.config
echo "ENVR=MANUAL" >> $EXAMPLES/Small_region_impute_run_info.config
echo 'LESS_NUM_SAMP="NO"' >> $EXAMPLES/Small_region_impute_run_info.config
#runing the impute job
$PERL  $EZIMPUTER/Phase_Impute_by_parallel_proc.pl -run_config $EXAMPLES/Small_region_impute_run_info.config -tool_config $TOOLINFO

#check the output files
if [ $? -ne 0 ]
then
	echo "Some error occured while running Phase_Impute_by_parallel_proc.pl script, Check the temp directory specified in the config file"
	exit
else
	echo "Check the output files in the temp directory specified in the config file "
fi



