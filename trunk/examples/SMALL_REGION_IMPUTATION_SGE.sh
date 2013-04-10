# This assumes you already created a tool_info.config file in the main directory where you installed the tools.
#
#set your ezimputer program directory
export EZIMPUTER=/data2/bsi/staff_analysis/m037385/ezimputer/ezimputer_code
#set your working directory
export EXAMPLES=/data2/bsi/staff_analysis/m037385/ezimputer/ezimputer_code/examples

#$EZIMPUTER/make_tool_info.sh $EZIMPUTER > $EXAMPLES/tool_info.config
$EZIMPUTER/make_tool_info.sh $EZIMPUTER > $EXAMPLES/tool_info.config

export TOOLINFO=$EXAMPLES/tool_info.config

PERL=`grep 'PERL=' $TOOLINFO | cut -d '=' -f2`


#First you need to run the WHOLE_GENOME_IMPUTATION.sh to generate the WHOLE_GENOME PLINK dataset
#unzip the ted file
cd $EXAMPLES



gunzip $EXAMPLES/fwdStrandResults_input.tped.gz
#extracting smalle region from whole genome
# Before running this script, you must run the whole genome workflow example up to the QC Step to generate the fwdStrandResults_input file
$EZIMPUTER/EXTERNALTOOLS/PLINK/plink --tfile $EXAMPLES/fwdStrandResults_input --chr 2 --from-kb 3500 --to-kb 6000 --transpose --recode --out $EXAMPLES/small_region_fwdStrandResults_input
#compress the tped file
gzip $EXAMPLES/small_region_fwdStrandResults_input.tped

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
echo "SGE_SHAPEIT_MEM=10G"  >> $EXAMPLES/Small_region_impute_run_info.config
echo "SGE_SHAPEIT_QUEUE=7-days"  >> $EXAMPLES/Small_region_impute_run_info.config
echo "SGE_IMPUTE_MEM=10G"  >> $EXAMPLES/Small_region_impute_run_info.config
echo "SGE_IMPUTE_QUEUE=1-day"  >> $EXAMPLES/Small_region_impute_run_info.config
echo "IMPUTEREF_VERSION=ALL_1000G_phase1integrated_v3"  >> $EXAMPLES/Small_region_impute_run_info.config
echo "LOCALTEMP_SHAPEIT=4G"  >> $EXAMPLES/Small_region_impute_run_info.config
echo "LOCALTEMP_IMPUTE=1G"  >> $EXAMPLES/Small_region_impute_run_info.config
echo "INNER_DIR=SMALL_REGION_IMPUTE"  >> $EXAMPLES/Small_region_impute_run_info.config
echo "RESTART=NO"  >> $EXAMPLES/Small_region_impute_run_info.config
echo "USERNAME=username"  >> $EXAMPLES/Small_region_impute_run_info.config
echo "SHAPEITONLY=NO"  >> $EXAMPLES/Small_region_impute_run_info.config
echo "LOCALTEMP=${EXAMPLES}/temp/LOCALTEMP"  >> $EXAMPLES/Small_region_impute_run_info.config
echo "SHAPEIT_STATESPHASE=100"  >> $EXAMPLES/Small_region_impute_run_info.config
echo "PBS=NO"  >> $EXAMPLES/Small_region_impute_run_info.config
echo "CHR_START_INPUT=YES"  >> $EXAMPLES/Small_region_impute_run_info.config
echo "SMALL_REGION_EXTN_START= 2000000"  >> $EXAMPLES/Small_region_impute_run_info.config
echo "SMALL_REGION_EXTN_STOP= 2000000"  >> $EXAMPLES/Small_region_impute_run_info.config
echo "WINDOW_CUTOFF_NUM_MARKERS=200"  >> $EXAMPLES/Small_region_impute_run_info.config
echo "EDGE_CUTOFF_NUM_MARKERS=50"  >> $EXAMPLES/Small_region_impute_run_info.config

#runing the impute job
$PERL $EZIMPUTER/bin/Phase_Impute_by_parallel_proc.pl -run_config $EXAMPLES/Small_region_impute_run_info.config -tool_config $TOOLINFO

