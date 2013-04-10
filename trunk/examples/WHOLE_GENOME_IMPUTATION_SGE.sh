#Set your ezimputer program directory
set -x
export EZIMPUTER=/data2/bsi/staff_analysis/m037385/ezimputer/ezimputer_code
#replace the path for example with your working directory
export EXAMPLES=/data2/bsi/staff_analysis/m037385/ezimputer/test
#get the hapmap data
# Here you would replace this script with command to get your own data.
cd $EXAMPLES
#wget http://hapmap.ncbi.nlm.nih.gov/downloads/genotypes/hapmap3_r3/plink_format/hapmap3_r3_b36_fwd.consensus.qc.poly.map.gz
#wget http://hapmap.ncbi.nlm.nih.gov/downloads/genotypes/hapmap3_r3/plink_format/hapmap3_r3_b36_fwd.consensus.qc.poly.ped.gz
#Uncompress(gunzip) them and convert the plink files to plink transpose files (this may take ~1 hour)
#gunzip hapmap3_*.gz


#download & prepare external tools
# Skip this if you have already installed the tools.. and set TOOLINFO to the path/name of your tool_info.config file
$EZIMPUTER/install_tools.sh $EZIMPUTER
make tool_info.config file
$EZIMPUTER/make_tool_info.sh $EZIMPUTER > $EXAMPLES/tool_info.config

export TOOLINFO=$EXAMPLES/tool_info.config


PERL=`grep 'PERL=' $TOOLINFO | cut -d '=' -f2`

#convert the plink file format to transpose
PLINK=`grep 'PLINK='  $TOOLINFO | cut -d '=' -f2 `
$PLINK --file $EXAMPLES/hapmap3_r3_b36_fwd.consensus.qc.poly --transpose --recode --out $EXAMPLES/hapmap3_r3_b36_fwd.consensus.qc.poly

#get imputataion reference
mkdir $EXAMPLES/impute_ref

$PERL  $EZIMPUTER/Get_impute_reference.pl  -OUT_REF_DIR  $EXAMPLES/impute_ref  -DOWNLOAD_LINK   http://mathgen.stats.ox.ac.uk/impute/ALL_1000G_phase1integrated_v3_impute.tgz 

#Upgrade the hapmap markers from build 36  to build 37 by using the script #Upgrade_inputmarkers_to_build37_by_DBSNP*.
$PERL   $EZIMPUTER/Upgrade_inputmarkers_to_build37_by_DBSNP.pl   -DBSNP_DIR $EXAMPLES/DBDIR/ -DBSNP_DOWNLOADLINK ftp://ftp.ncbi.nlm.nih.gov/snp/organisms/human_9606/database/organism_data/b137_SNPChrPosOnRef.bcp.gz -INPUT_FILE  $EXAMPLES/hapmap3_r3_b36_fwd.consensus.qc.poly.tped -REMAPPED_CURRENT_BUILD   $EXAMPLES/hapmap3_r3_b36_fwd.consensus.qc.poly_build37.tped -NOTMAPPED_OLD_BUILD   $EXAMPLES/hapmap3_r3_b36_fwd.consensus.qc.poly_build36.tped 
cp $EXAMPLES/hapmap3_r3_b36_fwd.consensus.qc.poly.tfam $EXAMPLES/hapmap3_r3_b36_fwd.consensus.qc.poly_build37.tfam

#check the plink dataset to remove duplicate position and replace duplicate rsid's in the TPED file and sample names with fake id's in the tfam file
$PERL  $EZIMPUTER/Check_plink_data_ezimputer.pl -INPUT_FILE $EXAMPLES/hapmap3_r3_b36_fwd.consensus.qc.poly_build37 -OUTPUT_FILE $EXAMPLES/hapmap3_r3_b36_fwd.consensus.qc.poly_build37_final

#preparing run config file for the QC script
echo "TPED=${EXAMPLES}/hapmap3_r3_b36_fwd.consensus.qc.poly_build37_final.tped"  > $EXAMPLES/QC_run_info.config
echo "TFAM=${EXAMPLES}/hapmap3_r3_b36_fwd.consensus.qc.poly_build37_final.tfam"  >> $EXAMPLES/QC_run_info.config
echo "OUTPUT_FOLDER=${EXAMPLES}"  >> $EXAMPLES/QC_run_info.config
echo "TEMP_FOLDER=${EXAMPLES}/temp"  >> $EXAMPLES/QC_run_info.config
echo "IMPUTEREF_VERSION=ALL_1000G_phase1integrated_v3"  >> $EXAMPLES/QC_run_info.config
echo "GENOTYPE_PERCENT_CUTOFF=0.05"  >> $EXAMPLES/QC_run_info.config
echo "SAMPLE_PERCENT_CUTOFF=0.05"  >> $EXAMPLES/QC_run_info.config
echo "IMPUTE_REF=${EXAMPLES}/impute_ref/ALL_1000G_phase1integrated_v3_impute"  >> $EXAMPLES/QC_run_info.config
echo "INNER_DIR=QC"  >> $EXAMPLES/QC_run_info.config
echo "BEAGLE_REF_DB=${EXAMPLES}/BEAGLE"  >> $EXAMPLES/QC_run_info.config

#running the QC program
$PERL  $EZIMPUTER/QC_fwd_structure.pl  -run_config $EXAMPLES/QC_run_info.config -tool_config $TOOLINFO

#gzip the ouput tped file from above QC process
gzip $EXAMPLES/fwdStrandResults_input.tped

#preparing run config file for the Impute
echo "TPED=${EXAMPLES}/fwdStrandResults_input.tped.gz"  > $EXAMPLES/Impute_run_info.config
echo "TFAM=${EXAMPLES}/fwdStrandResults_input.tfam"  >> $EXAMPLES/Impute_run_info.config
echo "FORWARDSTRAND_IND=${EXAMPLES}/fwdStrandResults_input.ind"  >> $EXAMPLES/Impute_run_info.config
echo "TEMP_FOLDER=${EXAMPLES}/temp"  >> $EXAMPLES/Impute_run_info.config
echo "IMPUTE_REF=${EXAMPLES}/impute_ref/ALL_1000G_phase1integrated_v3_impute"  >> $EXAMPLES/Impute_run_info.config
echo "IMPUTE_WINDOW=5000000"  >> $EXAMPLES/Impute_run_info.config
echo "IMPUTE_EDGE=125"  >> $EXAMPLES/Impute_run_info.config
echo "HAPS=NA"  >> $EXAMPLES/Impute_run_info.config
echo "EMAIL=******.****@**.com"  >> $EXAMPLES/Impute_run_info.config
echo "SGE_SHAPEIT_MEM=10G"  >> $EXAMPLES/Impute_run_info.config
echo "SGE_SHAPEIT_QUEUE=7-days"  >> $EXAMPLES/Impute_run_info.config
echo "SGE_IMPUTE_MEM=10G"  >> $EXAMPLES/Impute_run_info.config
echo "SGE_IMPUTE_QUEUE=1-day"  >> $EXAMPLES/Impute_run_info.config
echo "IMPUTEREF_VERSION=ALL_1000G_phase1integrated_v3"  >> $EXAMPLES/Impute_run_info.config
echo "LOCALTEMP_SHAPEIT=4G"  >> $EXAMPLES/Impute_run_info.config
echo "LOCALTEMP_IMPUTE=1G"  >> $EXAMPLES/Impute_run_info.config
echo "INNER_DIR=IMPUTE"  >> $EXAMPLES/Impute_run_info.config
echo "RESTART=NO"  >> $EXAMPLES/Impute_run_info.config
echo "USERNAME=username"  >> $EXAMPLES/Impute_run_info.config
echo "SHAPEITONLY=NO"  >> $EXAMPLES/Impute_run_info.config
echo "LOCALTEMP=${EXAMPLES}/temp/LOCALTEMP"  >> $EXAMPLES/Impute_run_info.config
echo "SHAPEIT_STATESPHASE=100"  >> $EXAMPLES/Impute_run_info.config
echo "PBS=NO"  >> $EXAMPLES/Impute_run_info.config
echo "CHR_START_INPUT=NO"  >> $EXAMPLES/Impute_run_info.config
echo "WINDOW_CUTOFF_NUM_MARKERS=200"  >> $EXAMPLES/Impute_run_info.config
echo "EDGE_CUTOFF_NUM_MARKERS=50"  >> $EXAMPLES/Impute_run_info.config

#runing the impute job
$PERL  $EZIMPUTER/Phase_Impute_by_parallel_proc.pl -run_config $EXAMPLES/Impute_run_info.config -tool_config $TOOLINFO
