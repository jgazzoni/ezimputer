

#get current directory
use Cwd 'abs_path';
$line = abs_path($0);
chomp $line;
@DR_array = split('/',$line);
pop(@DR_array);
$dir = join("/",@DR_array);

use Getopt::Long;
&Getopt::Long::GetOptions(
'run_config=s'      => \$config,
'tool_config=s'      => \$toolconfig
);
if($config eq "" || $toolconfig  eq "")
{
	print "config file missing.Check for this program manual and create a config file \n";
	
	die "Retry with : perl  Phase_Impute_by_parallel_proc.pl  -run_config <PATH TO THE RUN CONFIG FILE> -tool_config <PATH TO THE TOOL CONFIG FILE>\n";
}
require "$dir/bin/CONFIG.pl";
getDetails($config);
my $tped= $config{"TPED"};
my $tfam = $config{"TFAM"};
my $dirtemp = $config{"TEMP_FOLDER"};
my $forward_ind = $config{"FORWARDSTRAND_IND"};
my $impute_ref = $config{"IMPUTE_REF"};
my $impute_window = $config{"IMPUTE_WINDOW"};
my $impute_edge = $config{"IMPUTE_EDGE"};
my $haps = $config{"HAPS"};
my $email = $config{"EMAIL"};
my $shapeit_mem = $config{"SHAPEIT_MEM"};
my $shapeit_queue = $config{"SHAPEIT_QUEUE"};
my $impute_mem = $config{"IMPUTE_MEM"};
my $impute_queue = $config{"IMPUTE_QUEUE"};
my $ref_keyword = $config{"IMPUTEREF_VERSION"};
my $localtempspace_shapeit = $config{"LOCALTEMP_SHAPEIT"};
my $localtempspace_impute = $config{"LOCALTEMP_IMPUTE"};
my $rounded = $config{"INNER_DIR"};
my $restart_impute = $config{"IMPUTE_RESTART"};
my $username = $config{"USERNAME"};
my $shapit_only = $config{"SHAPEITONLY"};
my $local_temp=$config{"LOCALTEMP"};
my $shapeit_states_phase=$config{"SHAPEIT_STATESPHASE"};
my $pbs=$config{"PBS"};
my $chr_start_input=$config{"CHR_START_INPUT"};
my $small_region_extn_start=$config{"SMALL_REGION_EXTN_START"};
my $small_region_extn_stop=$config{"SMALL_REGION_EXTN_STOP"};
my $cutoff =$config{"WINDOW_CUTOFF_NUM_MARKERS"};
my $edge_cutoff=$config{"EDGE_CUTOFF_NUM_MARKERS"};

#reading tool info parameters
getDetails($toolconfig);
my $PLINK= $config{"PLINK"};
my $PERL= $config{"PERL"};
my $SHAPEIT= $config{"SHAPEIT"};
my $IMPUTE= $config{"IMPUTE"};
my $GPROBS= $config{"GPROBS"};
my $JAVA= $config{"JAVA"};
my $QSUB= $config{"QSUB"};
my $SH= $config{"SH"};

$forward_ind =~ s/\s|\t|\r|\n//g;
$dirtemp =~ s/\s|\t|\r|\n//g;
$tped =~ s/\s|\t|\r|\n//g;
$tfam =~ s/\s|\t|\r|\n//g;
$impute_ref =~ s/\s|\t|\r|\n//g;
$impute_window=~ s/\s|\t|\r|\n//g;
$impute_edge=~ s/\s|\t|\r|\n//g;
$haps=~ s/\s|\t|\r|\n//g;
$email=~ s/\s|\t|\r|\n//g;
$shapeit_mem=~ s/\s|\t|\r|\n//g;
$shapeit_queue=~ s/\s|\t|\r|\n//g;
$impute_mem=~ s/\s|\t|\r|\n//g;
$impute_queue=~ s/\s|\t|\r|\n//g;
$ref_keyword=~ s/\s|\t|\r|\n//g;
$localtempspace_shapeit=~ s/\s|\t|\r|\n//g;
$localtempspace_impute=~ s/\s|\t|\r|\n//g;
$rounded=~ s/\s|\t|\r|\n//g;
$restart_impute=~ s/\s|\t|\r|\n//g;
$username=~ s/\s|\t|\r|\n//g;
$shapit_only=~ s/\s|\t|\r|\n//g;
$local_temp=~ s/\s|\t|\r|\n//g;
$shapeit_states_phase=~ s/\s|\t|\r|\n//g;
$pbs=~ s/\s|\t|\r|\n//g;
$chr_start_input=~ s/\s|\t|\r|\n//g;
$small_region_extn_start=~ s/\s|\t|\r|\n//g;
$small_region_extn_stop=~ s/\s|\t|\r|\n//g;
$cutoff=~ s/\s|\t|\r|\n//g;
$edge_cutoff=~ s/\s|\t|\r|\n//g;
$local_temp =~ s/\/$//g;

$PLINK=~ s/\s|\t|\r|\n//g;
$PERL=~ s/\s|\t|\r|\n//g;
$SHAPEIT=~ s/\s|\t|\r|\n//g;
$IMPUTE=~ s/\s|\t|\r|\n//g;
$GPROBS=~ s/\s|\t|\r|\n//g;
$JAVA=~ s/\s|\t|\r|\n//g;
$QSUB=~ s/\s|\t|\r|\n//g;
$SH=~ s/\s|\t|\r|\n//g;


print "***********RUNINFO CONFIG INPUT ARGUMENTS***********\n";
print "TPED: $tped\n";
print "TFAM: $tfam\n";
print "TEMP_FOLDER: $dirtemp\n";
print "FORWARDSTRAND_IND: $forward_ind\n";
print "IMPUTE_REF: $impute_ref\n"; 
print "IMPUTE_WINDOW: $impute_window\n";
print "IMPUTE_EDGE: $impute_edge\n";
print "HAPS: $haps\n";
print "SAMP_SHAPEIT: $samp_shapeit\n";
print "EMAIL: $email\n"; 
print "SHAPEIT_MEM: $shapeit_mem\n";
print "SHAPEIT_QUEUE: $shapeit_queue\n";
print "IMPUTE_MEM: $impute_mem\n";
print "IMPUTE_QUEUE: $impute_queue\n";
print "IMPUTEREF VERSION: $ref_keyword\n";
print "Local tempspace for impute $localtempspace_impute\n";
print "Local tempspace for shapeit $localtempspace_shapeit\n";
print "ROUNDED $rounded\n";
print "IMPUTE_RESTART : $restart_impute\n";
print "USERNAME : $username\n";
print "SHAPEIT ONLY : $shapit_only\n";
print "LOCALTEMP : $local_temp\n";
print "SHAPEIT STATE PHASES : $shapeit_states_phase\n";
print "PBS : $pbs\n";
print "CHR_START_INPUT : $chr_start_input\n";
print "SMALL_REGION_EXTN_START : $small_region_extn_start\n";
print "SMALL_REGION_EXTN_STOP : $small_region_extn_stop\n";
print "WINDOW_CUTOFF_NUM_MARKERS : $cutoff\n";
print "EDGE_CUTOFF_NUM_MARKERS : $edge_cutoff\n";

print "***********INPUT ARGUMENTS FOR TOOL CONFIG FILE***********\n";
print "PLINK: $PLINK\n";
print "PERL: $PERL\n";
print "SHAPEIT: $SHAPEIT\n";
print "IMPUTE: $IMPUTE\n";
print "GPROBS: $GPROBS\n";
print "JAVA: $JAVA\n";
print "QSUB: $QSUB\n";
print "SH: $SH\n";

#checking for the right tool info config file parameters
if($SH eq "" |$JAVA eq "" |$QSUB eq "" | $PLINK eq "" | $PERL eq "" |  $SHAPEIT eq "" | $IMPUTE eq "" |$GPROBS eq "" )
{
	die "input TOOL CONFIG FILE arguments empty please correct arguments and retry\n";
} 

#checking for the tools mentioned in the tool config file if exists
if(!(-e $SH) | !(-e $JAVA) | !(-e $QSUB) | !(-e $PLINK) | !(-e $PERL) | !(-e $SHAPEIT) | !(-e $IMPUTE) | !(-e $GPROBS) )
{
	die "input TOOL config file executables doesnot exist.Please recheck for input config file executables\n";
}

#checking impute window and edge sizes
if(!($impute_window >= 2000000 && $impute_window <= 5000000))
{
	die "impute window should be between 2 and 5 mb\n";
}
if($impute_edge != 125)
{
	#die "impute edge should be 125 in kb\n";
}
$dirtemp =~ s/\/$//g;
$impute_ref =~ s/\/$//g;
if($chr_start_input =~ m/\w/ && $small_region_extn_start !~ m/\d/ && $small_region_extn_stop !~ m/\d/)
{
	die "$small_region_extn_start and $small_region_extn_stop should be number\n";
}
if($edge_cutoff eq "" | $cutoff eq "" | $chr_start_input eq "" | $shapeit_states_phase eq "" |$local_temp eq "" | $shapit_only eq "" | $username eq "" |$dirtemp eq "" | $tped eq "" | $tfam eq ""  | $impute_ref eq "" | $impute_window eq "" | $impute_edge eq "" | $haps eq "" | $email eq "" | $shapeit_mem eq "" | $shapeit_queue eq "" | $impute_mem eq "" | $impute_queue eq "")
 {
	die "input arguments empty please correct arguments and retry\n";
 }
 if($shapeit_states_phase <100)
 {
	die "shapeit_states_phase parameter should be greater than 99\n";
 }
  
 if(!(-e $tped) | !(-e $tfam))
 {
	 die "input tfam or tped file does not exist\n";
 }
unless(-d $dirtemp)
{
    system("mkdir -p $dirtemp");
}

if(!(-d $impute_ref))
 {
	die "impute ref directory not found\n";
 }
 if(uc($haps) ne "NA" && !(-e $haps)) 
 {
	die "input haps  does not exist\n";
 }
if(uc($rounded) eq "NA")
{
	$round = sprintf("%.0f", rand()*time());
	$rounded = "temp".$round;
}

if(uc($restart_impute) ne "YES")
{

	#creating a temp directory if not presen
	system("mkdir -p $dirtemp");
	system("mkdir $dirtemp/$rounded");
	#system("cp $tfam  $dirtemp/$rounded/");
	#@tfam_ar=split(/\//,$tfam);
	#$tfam = pop(@tfam_ar);
	
	system("cp $tfam $dirtemp/$rounded/unprocessed_input.tfam");
	system("cp $tped $dirtemp/$rounded/unprocessed_input.tped.gz"); 
	#system("cp $tped $dirtemp/$rounded/unprocessed_input.tped.gz");
	system("gunzip $dirtemp/$rounded/unprocessed_input.tped.gz");
	#checking if data contain chr x then checking for gender information in the tfam file
	$verify=`cut -f5 -d ' ' $dirtemp/$rounded/unprocessed_input.tfam|sort|uniq`;
	@verify=split("\n",$verify);
	open(CHECK_X,"$dirtemp/$rounded/unprocessed_input.tped") or die " no file found $dirtemp/$rounded/unprocessed_input.tped\n";
	$chrx_check=0;
	
	while(<CHECK_X>)
	{
		if($_ =~ m/^23 /)
		{
			$chrx_check=1;
		}
	}
	print "chrx_check $chrx_check\n";
	if($chrx_check==1)
	{
		for($i=0;$i<@verify;$i++)
		{
			if($verify[$i] =~ m/\D/ || $verify[$i] < 1 || $verify[$i] > 2)
			{
				die "tfam file should contain gender information 1 (male) 2 (Female)\n";
			}
		}
	}	
	#system("cp $dirtemp/$rounded/unprocessed_input.tfam $dirtemp/$rounded/processed_beagle_input.tfam");
	#system("$PLINK --tfile $dirtemp/$rounded/unprocessed_input --transpose --recode --out $dirtemp/$rounded/processed_beagle_input");
	system("$PLINK --tfile $dirtemp/$rounded/unprocessed_input --make-bed --out $dirtemp/$rounded/processed_beagle_input");
	system("rm  $dirtemp/$rounded/unprocessed_input.*");

	
	#system("$PLINK --tfile $dirtemp/$rounded/processed_beagle_input --out $dirtemp/$rounded/processed_beagle_input --make-bed");
	#system("rm $dirtemp/$rounded/processed_beagle_input.tfam $dirtemp/$rounded/processed_beagle_input.tped");
	#system("rm $dirtemp/$rounded/unprocessed_beagle_input.tfam $dirtemp/$rounded/unprocessed_beagle_input.tped");

	#checking for the chr23 exists
	open(CHECK,"$dirtemp/$rounded/processed_beagle_input.bim") or die "no file exists\n";
	#@check_chr = (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23);
	#$prev_chr = 0;
	while(<CHECK>)
	{
		@array = split("\t",$_);
		$check_x{$array[0]} = 1;
	}
	foreach my $key (sort { $a <=> $b} keys %check_x) 
	{
		push(@check_chr,$key);
	}
	print "chromosomes existsed @check_chr\n";
	close(CHECK);
	if(uc($haps) eq "NA")
	{
		#chopping the chr 1-22 and submitting the jobs for imputation
		#creating the argument file for the array job for the shape it program
		open(ARRAY_WRBUFF,">$dirtemp/$rounded/ArrayJob_file_shapeit")or die "unable to write the file ArrayJob_file_shapeit\n";
		open(GUNZIP_SHAPIT_WRBUFF,">$dirtemp/$rounded/Gunzip_file_shapeit")or die "unable to write the file Gunzip_file_shapeit\n";
		@check_chr_t=();
		for($i=0;$i<@check_chr;$i++)
		{
			if($check_chr[$i] <24)
			{
				push(@check_chr_t,$check_chr[$i]);
			}
		}
		undef(@check_chr);
		@check_chr = ();
		for($i=0;$i<@check_chr_t;$i++)
                {
                        if($check_chr_t[$i] <24)
                        {
                                push(@check_chr,$check_chr_t[$i]);
                        }
                }
		undef(@check_chr_t);	
		for($i=0;$i<@check_chr;$i++)
		{
			$j = $check_chr[$i];
			#if($j < 24)
			#{
				system("mkdir $dirtemp/$rounded/$j");
				system("$PLINK --bfile $dirtemp/$rounded/processed_beagle_input --chr $j --make-bed  --out $dirtemp/$rounded/$j/snps_chr$j");
				if($j == 23)
				{
					#print ARRAY_WRBUFF "--input-bed  $dirtemp/$rounded/$j/snps_chr$j.bed $dirtemp/$rounded/$j/snps_chr$j.bim $dirtemp/$rounded/$j/snps_chr$j.fam --input-map $impute_ref/genetic_map_chrX_nonPAR_combined_b37.txt  --output-max  $dirtemp/$rounded/$j/snps_chr$j.haps $dirtemp/$rounded/$j/snps_chr$j.sample\n"; 
					if(uc($pbs) ne "YES")
					{
						print ARRAY_WRBUFF "--input-bed  $dirtemp/$rounded/$j/snps_chr$j.bed $dirtemp/$rounded/$j/snps_chr$j.bim $dirtemp/$rounded/$j/snps_chr$j.fam --input-map $impute_ref/genetic_map_chrX_nonPAR_combined_b37.txt  --output-max  snps_chr$j.haps snps_chr$j.sample --chrX --seed 123456789 --states-phase $shapeit_states_phase --output-log $dirtemp/$rounded/shapeit_logfiles_sungrid/$j\n"; 
					}
					else
					{
						print ARRAY_WRBUFF "--input-bed  $dirtemp/$rounded/$j/snps_chr$j.bed $dirtemp/$rounded/$j/snps_chr$j.bim $dirtemp/$rounded/$j/snps_chr$j.fam --input-map $impute_ref/genetic_map_chrX_nonPAR_combined_b37.txt  --output-max  $dirtemp/$rounded/$j/snps_chr$j.haps $dirtemp/$rounded/$j/snps_chr$j.sample --chrX --seed 123456789 --states-phase $shapeit_states_phase --output-log $dirtemp/$rounded/shapeit_logfiles_sungrid/$j\n"; 	
					}		
				}
				else
				{
					#$array_job = "--input-bed  $dirtemp/$rounded/$j/snps_chr$j.bed $dirtemp/$rounded/$j/snps_chr$j.bim $dirtemp/$rounded/$j/snps_chr$j.fam --input-map $impute_ref/genetic_map_chr$j"."_combined_b37.txt  --output-max  $dirtemp/$rounded/$j/snps_chr$j.haps $dirtemp/$rounded/$j/snps_chr$j.sample\n";
					if(uc($pbs) ne "YES")
					{
						$array_job = "--input-bed  $dirtemp/$rounded/$j/snps_chr$j.bed $dirtemp/$rounded/$j/snps_chr$j.bim $dirtemp/$rounded/$j/snps_chr$j.fam --input-map $impute_ref/genetic_map_chr$j"."_combined_b37.txt  --output-max  snps_chr$j.haps snps_chr$j.sample --seed 123456789 --states-phase $shapeit_states_phase --output-log $dirtemp/$rounded/shapeit_logfiles_sungrid/$j\n";
						print ARRAY_WRBUFF $array_job;
					}
					else
					{
						$array_job = "--input-bed  $dirtemp/$rounded/$j/snps_chr$j.bed $dirtemp/$rounded/$j/snps_chr$j.bim $dirtemp/$rounded/$j/snps_chr$j.fam --input-map $impute_ref/genetic_map_chr$j"."_combined_b37.txt  --output-max  $dirtemp/$rounded/$j/snps_chr$j.haps $dirtemp/$rounded/$j/snps_chr$j.sample --seed 123456789 --states-phase $shapeit_states_phase --output-log $dirtemp/$rounded/shapeit_logfiles_sungrid/$j\n";
						print ARRAY_WRBUFF $array_job;
					}
				}
				#print GUNZIP_SHAPIT_WRBUFF "gzip $dirtemp/$rounded/$j/snps_chr$j.haps\n";
				print GUNZIP_SHAPIT_WRBUFF "$dirtemp/$rounded/$j/\n";
				#system("$PLINK --bfile $dirtemp/$rounded/processed_beagle_input --chr $j  --transpose --recode --out $temp_dir/$j/snps_chr$j");
				#system("$PLINK --tfile $temp_dir/$j/snps_chr$j --missing --out $temp_dir/$j/snps_chr$j");
				#system("perl $dir/bin/perl_prep_impute.pl $temp_dir/$j/snps_chr$j");
			#}
		}
		close(ARRAY_WRBUFF);

		#system("gzip $dirtemp/$rounded/*.tped");
		$count_shapeit_jobs = `wc -l $dirtemp/$rounded/ArrayJob_file_shapeit`;
		$count_shapeit_jobs =~  s/ .*//g;
		chomp($count_shapeit_jobs);
		system("mkdir $dirtemp/$rounded/shapeit_logfiles_sungrid");
		open(ARRAY_SHAPEIT,">$dirtemp/$rounded/ArrayJob_shapeit.csh") or die "unable to create the array job file\n";
		if(-e "$dirtemp/$rounded/shapeit_check_jobs")
		{		
			system("rm $dirtemp/$rounded/shapeit_check_jobs");
			
		}
		system("touch $dirtemp/$rounded/shapeit_check_jobs");
		if(uc($pbs) ne "YES")
		{
			#print ARRAY_SHAPEIT $shapeit;
			$com = '#!';
			print ARRAY_SHAPEIT "$com $SH\n";
			$com = '#$';
			print ARRAY_SHAPEIT "$com -q $shapeit_queue\n";
			print ARRAY_SHAPEIT "$com -l h_vmem=$shapeit_mem\n";
			print ARRAY_SHAPEIT "$com -t 1-$count_shapeit_jobs:1\n";
			print ARRAY_SHAPEIT "$com -M $email\n";
			print ARRAY_SHAPEIT "$com -m a\n";
			print ARRAY_SHAPEIT "$com -l loc2tmp=$localtempspace_shapeit\n";
			print ARRAY_SHAPEIT "$com -V\n";
			print ARRAY_SHAPEIT "$com -cwd\n";
			print ARRAY_SHAPEIT "$com -e $dirtemp/$rounded/shapeit_logfiles_sungrid\n";
			print ARRAY_SHAPEIT "$com -o $dirtemp/$rounded/shapeit_logfiles_sungrid\n";
			print ARRAY_SHAPEIT "$com -notify\n";
			$temp = 'tmp='.$local_temp.'/'.$username.'/`expr $RANDOM \* $RANDOM`';
			print ARRAY_SHAPEIT "$temp\n";
			print ARRAY_SHAPEIT 'cleanup () {'."\n";
			print ARRAY_SHAPEIT '/bin/rm -rf $tmp'."\n";
			print ARRAY_SHAPEIT '}'."\n";
			print ARRAY_SHAPEIT "trap 'cleanup' USR1 USR2 EXIT\n";
			$temp = 'mkdir -p $tmp';
			print ARRAY_SHAPEIT "$temp\n";
			$temp = 'cd $tmp';
			print ARRAY_SHAPEIT "$temp\n";
			print ARRAY_SHAPEIT 't1=`pwd`'."\n";
			print ARRAY_SHAPEIT 't2=`uname -n`'."\n";
			print ARRAY_SHAPEIT 't3="$t1 $t2"'."\n";
			print ARRAY_SHAPEIT 'echo $t3 > '."$dirtemp/$rounded/shapeit_system\n";
			#print ARRAY_SHAPEIT "uname -n >> $dirtemp/$rounded/shapeit_system\n";
			$temp = 'k=`cat  '."$dirtemp/$rounded/ArrayJob_file_shapeit".' |head -$SGE_TASK_ID |tail -1`';
			print ARRAY_SHAPEIT "$temp\n";
			$temp = "$SHAPEIT ".'$k '."\n";
			print ARRAY_SHAPEIT "$temp";
			$temp='gzip snps_chr*.haps';
			print ARRAY_SHAPEIT "$temp\n";
			print ARRAY_SHAPEIT "wait\n";
			$temp = 'k1'.'=`cat  '."$dirtemp/$rounded/Gunzip_file_shapeit".' |head -$SGE_TASK_ID |tail -1`';
			print ARRAY_SHAPEIT "$temp\n";
			$temp = 'mv snps_chr* $k1';
			print ARRAY_SHAPEIT "$temp\n";
			$temp = 'rm -rf $tmp';
			print ARRAY_SHAPEIT "$temp\n";
			$temp = 'echo $SGE_TASK_ID >>'."$dirtemp/$rounded/shapeit_check_jobs\n";
			print ARRAY_SHAPEIT "$temp\n";
			#$temp = "cp $dirtemp/$rounded/ArrayJob_file_shapeit ".'$k1/waiting.txt'."\n";
			#print ARRAY_SHAPEIT "$temp\n";
		}
		else
		{
			$com = '#!';
			print ARRAY_SHAPEIT "$com $SH\n";
			$com = '#PBS';
			print ARRAY_SHAPEIT "$com -l walltime=10:05:00\n";
			print ARRAY_SHAPEIT "$com -l nodes=1:ppn=1\n";
			print ARRAY_SHAPEIT "$com -t 1-$count_shapeit_jobs\n";
			print ARRAY_SHAPEIT "$com -M $email\n";
			print ARRAY_SHAPEIT "$com -m a\n";
			print ARRAY_SHAPEIT "$com -A normal\n";
			print ARRAY_SHAPEIT "$com -V\n";
			print ARRAY_SHAPEIT "$com -A bf0\n";
			print ARRAY_SHAPEIT "$com -e $dirtemp/$rounded/shapeit_logfiles_sungrid\n";
			print ARRAY_SHAPEIT "$com -o $dirtemp/$rounded/shapeit_logfiles_sungrid\n";
			$temp = "$SHAPEIT ".'`cat  '."$dirtemp/$rounded/ArrayJob_file_shapeit".' |head -${PBS_ARRAYID} |tail -1`'."\n";
			print ARRAY_SHAPEIT "$temp\n";
			$temp='gzip '.'`cat  '."$dirtemp/$rounded/Gunzip_file_shapeit".' |head -${PBS_ARRAYID} |tail -1`'.'snps_chr*.haps';
			print ARRAY_SHAPEIT "$temp\n";
			#$temp = "cp $dirtemp/$rounded/ArrayJob_file_shapeit ".'`cat  '."$dirtemp/$rounded/Gunzip_file_shapeit".' |head -${PBS_ARRAYID} |tail -1`'."/waiting.txt\n";
			$temp = 'echo ${PBS_ARRAYID} >>'."$dirtemp/$rounded/shapeit_check_jobs\n";
			print ARRAY_SHAPEIT "$temp\n";
			#print ARRAY_SHAPEIT "wait\n";
			#$temp = 'mv snps_chr* '.'`cat  '."$dirtemp/$rounded/Gunzip_file_shapeit".' |head -${PBS_ARRAYID} |tail -1`';
			#print ARRAY_SHAPEIT "$temp\n";
			#$temp = 'rm -rf $tmp';
			#print ARRAY_SHAPEIT "$temp\n";
		}	
		#submitting and storing the job id
		#die "qsub $dirtemp/$rounded/ArrayJob_shapeit.csh > $dirtemp/$rounded/jobid_shapeit\n";
		
		if(uc($pbs) ne "YES")
		{
			system("$QSUB $dirtemp/$rounded/ArrayJob_shapeit.csh > $dirtemp/$rounded/jobid_shapeit");
			
			#readin job id from submit_shapeit
			open(ARRAY_SHAPEIT,"$dirtemp/$rounded/jobid_shapeit") or die "unable to open file $dirtemp/$rounded/jobid_shapeit\n";
			$shapeit = <ARRAY_SHAPEIT>;
			print "$shapeit\n";
			@shapeit =split(" ",$shapeit);
			@shapeit1 =split(/\./,$shapeit[2]);
			print "JOB ID $shapeit1[0]\n";
			$job_id_shapeit = $shapeit1[0];
		}
		else
		{
			system(" $QSUB $dirtemp/$rounded/ArrayJob_shapeit.csh > $dirtemp/$rounded/jobid_shapeit");
				#readin job id from submit_shapeit
			open(ARRAY_SHAPEIT,"$dirtemp/$rounded/jobid_shapeit") or die "unable to open file $dirtemp/$rounded/jobid_shapeit\n";
			$shapeit = <ARRAY_SHAPEIT>;
			print "$shapeit\n";
			@shapeit1 =split(/\./,$shapeit);
			#$shapeit1[0]=~ s/\[\]//g;
			print "JOB ID $shapeit1[0]\n";
			$job_id_shapeit = $shapeit1[0];
		}
		#die $job_id_shapeit."\n";
		#making the array job to wait
		open(ARRAY_SHAPEIT,">$dirtemp/$rounded/ArrayJob_shapeit_wait.csh") or die "unable to create the array job wait file shape it \n";
		if(uc($pbs) ne "YES")
		{
			print ARRAY_SHAPEIT '#! '."$SH\n";
			print ARRAY_SHAPEIT '#$ -q 1-hour'."\n";
			print ARRAY_SHAPEIT '#$ -l h_vmem=2G'."\n";
			print ARRAY_SHAPEIT '#$ -M '."$email\n";
			print ARRAY_SHAPEIT '#$ -m a'."\n";
			print ARRAY_SHAPEIT '#$ -V'."\n";
			print ARRAY_SHAPEIT '#$ -cwd'."\n";
			$com = '#$';
			print ARRAY_SHAPEIT "$com -e $dirtemp/$rounded/\n";
			print ARRAY_SHAPEIT "$com -o $dirtemp/$rounded/\n";
			#if(-e "$dirtemp/$rounded/waiting.txt")
			#{
			#	system("rm $dirtemp/$rounded/waiting.txt");
			#}
			print ARRAY_SHAPEIT "cp $dirtemp/$rounded/jobid_shapeit $dirtemp/$rounded/waiting.txt\n";
			$sys = "$QSUB -hold_jid $job_id_shapeit $dirtemp/$rounded/ArrayJob_shapeit_wait.csh\n";
			print $sys."\n";
			system($sys);	
		}
		else
		{
			$com = '#!';
			print ARRAY_SHAPEIT "$com $SH\n";
			$com = '#PBS';
			print ARRAY_SHAPEIT "$com -l walltime=01:05:00\n";
			print ARRAY_SHAPEIT "$com -l nodes=1:ppn=1\n";
			print ARRAY_SHAPEIT "$com -M $email\n";
			print ARRAY_SHAPEIT "$com -m a\n";
			print ARRAY_SHAPEIT "$com -A normal\n";
			print ARRAY_SHAPEIT "$com -V\n";
			print ARRAY_SHAPEIT "$com -A bf0\n";
			print ARRAY_SHAPEIT "$com -e $dirtemp/$rounded/\n";
			print ARRAY_SHAPEIT "$com -o $dirtemp/$rounded/\n";
			print ARRAY_SHAPEIT "cp $dirtemp/$rounded/jobid_shapeit $dirtemp/$rounded/waiting.txt\n";
			$sys = "$QSUB -W depend=afterokarray:$job_id_shapeit $dirtemp/$rounded/ArrayJob_shapeit_wait.csh\n";
			print $sys."\n";
			system($sys);
		
		}
		$flag = 1;
		while($flag > 0)
		{
			#print "in the loop\n";
			if($flag%100000000 == 0)
				{
						$flag = 1;
						print "waiting for the shapeit array job to complete\n";
				}
			$flag++;

			#$countShapeit=`wc -l $dirtemp/$rounded/shapeit_check_jobs`;
			#chomp($countShapeit);
			#$countShapeit =~ s/ \w+//g;
			#@countShapeit = split(" ",$countShapeit);
			#print "test1 $countShapeit[0] \n";
			#if($countShapeit[0] eq $count_shapeit_jobs)
			if(-e "$dirtemp/$rounded/waiting.txt")	
			{
					$flag =0;
			}
		}		
		#print "successfully completed\n";
		if(-e "$dirtemp/$rounded/waiting.txt")
		{
				system("rm $dirtemp/$rounded/waiting.txt");
		}
		
		
		#removing all the jobs
		#open(SYS,"$dirtemp/$rounded/shapeit_system") or die "no file exists $dirtemp/$rounded/shapeit_system\n";
		#while(<SYS>)
		#{
		#	chomp($_);
		#		if($_ =~ m/^\/local2\/tmp\//)
		#	{
		#		@sys = split(" ",$_);
		#		if($sys[0] ne "" && $sys[0] =~ m/\w/)
		#		{
		#			$sys = 'rsh -l '.$username.' '.$sys[1].' "'.'rm -rf '.$sys[0].'"';
		#			print "executing $sys\n";
		#			system($sys);
		#		}
		#	}		
		#}	
		
		#checking all the jobs of shape it are sucessful
		$flag = 1;
		$check_order_sample = 0;
		
		for($i=0;$i<@check_chr;$i++)
		{
			$j = $check_chr[$i];
			$count_shapeit =`gunzip -c  $dirtemp/$rounded/$j/snps_chr$j.haps.gz| wc -l `;
			chomp($count_shapeit);
			$count_shapeit =~ s/\s.+//g;
			if(!((-e "$dirtemp/$rounded/$j/snps_chr$j.haps.gz") && (-e "$dirtemp/$rounded/$j/snps_chr$j.sample") && $count_shapeit > 0 ))
			{
				print "Shape it job not successful for chr$j\n";
				$flag =2;
			} 
			#mainly to compare sample order of input to sample order after shapeit jobs are done
			else
			{
				open(SAMPLEORDER,"$dirtemp/$rounded/$j/snps_chr$j.fam") or die "no file exists\n";
				if($check_order_sample == 0)
				{
					
					while(<SAMPLEORDER>)
					{
						chomp($_);
						@sampleorder = split(" ",$_);
						$hash_sampleorder{$sampleorder[1]} =$check_order_sample++;
					}
				}
				$check_order_sample = 0;
				open(SAMPLEORDER,"$dirtemp/$rounded/$j/snps_chr$j.sample") or die "no file exists\n";
				$line = <SAMPLEORDER>;
				$line = <SAMPLEORDER>;
				while(<SAMPLEORDER>)
				{
					chomp($_);
					@sampleorder = split(" ",$_);
					if((!exists($hash_sampleorder{$sampleorder[1]})) || $hash_sampleorder{$sampleorder[1]} != $check_order_sample)
					{
						die "shapeit order doesnot match with input data\n";
					}
					$check_order_sample++;
				}	
				
			}
		}
		if($flag ==2)
		{
			die "shape it jobs failed\n";
		}
		for($i=0;$i<@check_chr;$i++)
		{
			$j = $check_chr[$i];
			if($j != 23)
			{
				system("rm $dirtemp/$rounded/$j/snps_chr$j.fam $dirtemp/$rounded/$j/snps_chr$j.bed $dirtemp/$rounded/$j/snps_chr$j.bim");
			}
			else
			{
				system("rm $dirtemp/$rounded/$j/snps_chr$j.bed $dirtemp/$rounded/$j/snps_chr$j.bim");
			}
		}
		undef(@check_chr);
		undef(%hash_sampleorder);
		system("rm $dirtemp/$rounded/shapeit_logfiles_sungrid/*");
		system("rmdir $dirtemp/$rounded/shapeit_logfiles_sungrid/");
	}

	else
	{
		$sys = "tar -C $dirtemp/$rounded -xzf $haps";
		system($sys);
	}

	#looking for directories from shapeit
	undef(@check_chr);
	@ls = `ls -d $dirtemp/$rounded/*`;
	for($i=0;$i<@ls;$i++)
	{
			chomp($ls[$i]);
			@array = split(/\//,$ls[$i]);
			$chr = pop(@array);
			if($chr =~ m/^\d+$/ && $chr <24)
			{
					#print "$chr\n";
					push(@check_chr,$chr);
			}
			undef(@array);
			#print "$ls[$i]\n";
	}
	@check_chr = sort {$a <=> $b} @check_chr;
	print "@check_chr\n";
	#checking whether the haps files with original files
	system("$PLINK --bfile $dirtemp/$rounded/processed_beagle_input --transpose --recode --out $dirtemp/$rounded/processed_beagle_input");	
	#shape it QC file for comparing haps file with observed data
	open(SHAPE_CHECK,">$dirtemp/$rounded/shapeit_QC") or die "not able to write shapeit_QC\n";
	print SHAPE_CHECK "CHR MARKER NUM_MISMATCH_SAMP\n";
	$totalnum_markers=0;
	$shapeqc_num_markers=0;
	for($i=0;$i<@check_chr;$i++)
	{	
		$j = $check_chr[$i];
		open(HAP_CHECK,"gunzip -c $dirtemp/$rounded/$j/snps_chr$j.haps.gz |") or die "no haps gzip $j file found\n";
		open(WRHAP_CHECK,"|gzip >  $dirtemp/$rounded/$j/check_snps_chr$j.haps.gz") or die " not able to write file temp_snps_chr$j.haps.gz\n";
		$temp_ch="'^".$j." '";
		open(INPUT_CHECK,"grep -P $temp_ch $dirtemp/$rounded/processed_beagle_input.tped |") or die "no file processed_beagle_input.tped file found\n";
		while($ch_input=<INPUT_CHECK>)
		{
			chomp($ch_input);
			$ch_hap=<HAP_CHECK>;
			chomp($ch_hap);
			@ch_input=split(" ",$ch_input);
			@ch_hap=split(" ",$ch_hap);
			shift(@ch_input);
			$in_rsid=shift(@ch_input);
			shift(@ch_input);
			$in_pos=shift(@ch_input);
			print WRHAP_CHECK shift(@ch_hap);
			$hp_rsid=shift(@ch_hap);
			$hp_pos=shift(@ch_hap);
			$hp_a1=shift(@ch_hap);
			$hp_a2=shift(@ch_hap);
			print WRHAP_CHECK " $hp_rsid $hp_pos $hp_a1 $hp_a2";
			$num_hap_check=0;
			if($hp_rsid ne $in_rsid || $in_pos ne $hp_pos ||@ch_hap ne @ch_input)
			{
				die "chr $j haps file marker not equal to input marker $hp_rsid ne $in_rsid || $in_pos ne $hp_pos\n";
			}
			$ch_input=join(" ",@ch_input);
			$ch_input=~ s/0/3/g;
			$ch_input=~ s/$hp_a2/1/g;
			$ch_input=~ s/$hp_a1/0/g;
			
			@ch_input=split(" ",$ch_input);
			$totalnum_markers++;
			for($k=0;$k<@ch_input;$k++)
			{
				$a3=$ch_hap[$k];
				$a1=$ch_input[$k++];
				$a2=$ch_input[$k];
				$a4=$ch_hap[$k];
				if(($a1 == 3 && $a2 == 3) || "$a1 $a2" eq "$a3 $a4" || "$a2 $a1" eq "$a3 $a4")
				{
					print WRHAP_CHECK " $a3 $a4";
				}
				else
				{
					print WRHAP_CHECK " $a1 $a2";
					$num_hap_check++;	
					#print "INPUT CHECK sucess $a1 $a2 $a3 $a4\n";	
				}
				
			}
			print WRHAP_CHECK "\n";
			if($num_hap_check > 0)
			{
				$shapeqc_num_markers++;
				print SHAPE_CHECK $j." ".$in_rsid." ".$num_hap_check."\n";
			}
		}
		close(WRHAP_CHECK);
		close(HAP_CHECK);
		close(INPUT_CHECK);	
		#die "check $line\n";
		system("mv $dirtemp/$rounded/$j/snps_chr$j.haps.gz $dirtemp/$rounded/$j/ori_snps_chr$j.haps.gz");
		system("mv $dirtemp/$rounded/$j/check_snps_chr$j.haps.gz $dirtemp/$rounded/$j/snps_chr$j.haps.gz");
	}
	close(SHAPE_CHECK);
	# if($shapeqc_num_markers/$totalnum_markers > 0.05)
	# {
		# die "$shapeqc_num_markers of observed markers out of $totalnum_markers got changed by the shapeit tool.Please look at the file $dirtemp/$rounded/shapeit_QC\n";
	# }
	
	#die;
	#taring the directories
	system("mkdir $dirtemp/$rounded/SHAPEIT");
	if(@check_chr <1)
	{
		die "no chromsomes in the analysis left after shape it\n";
	}
	
	for($i=0;$i<@check_chr;$i++)
	{	
		$j = $check_chr[$i];
		$sys="cp -R $dirtemp/$rounded/$j $dirtemp/$rounded/SHAPEIT"; 
		#print "$sys\n";
		system($sys);
	}
	$sys="tar -zcf $dirtemp/$rounded/shapeit_jobs.tar.gz -C $dirtemp/$rounded/SHAPEIT .";
	print "$sys\n";
	system($sys);
	
	$sys = "rm -rf $dirtemp/$rounded/SHAPEIT";
	print "$sys\n";
	system($sys);
	
	if(uc($shapit_only) eq "YES")
	{
		print "SHAPEIT ONLY JOB SO existed see RESULTS IN TEMP FOLDER\n";
		exit 0;
	}

	#input plink file processing according to fwdmap file and ref file
	system("$PLINK --bfile $dirtemp/$rounded/processed_beagle_input --transpose --recode --out $dirtemp/$rounded/processed_beagle_input");
	system("wait");
	system("mv $dirtemp/$rounded/processed_beagle_input.tped $dirtemp/$rounded/unprocessed_beagle_input.tped");
	system("gzip $dirtemp/$rounded/unprocessed_beagle_input.tped");
	$command_sys = "$PERL $dir/bin/process_fwdstnd_beagle_input.pl -f $dirtemp/$rounded/unprocessed_beagle_input.tped.gz -h $impute_ref  -n $dirtemp/$rounded/processed_beagle_input.tped -e $dirtemp/$rounded/excluded_no_hapmap_processed_beagle_input.tped.gz -a $dirtemp/$rounded/ambi_hapmap_processed_beagle_input.tped.gz -u $dirtemp/$rounded/unsure_differentallele.tped.gz  -i $forward_ind -v $ref_keyword ";
	print $command_sys."\n";
	system($command_sys);
	#die;
	#checking for non empty output file from processed file
	$count_pro =`wc -l $dirtemp/$rounded/processed_beagle_input.tped`;
	chomp($count_pro);
	$count_pro =~ s/\s.+//g;
	if($count_pro < 10)
	{
		die "processed file doesn't have any rows\n";
	}
		
	#die "test @check_chr\n";
	#running impute on these files steps
	#creating the xchr imputation sample file sex information
	if($check_chr[@check_chr-1] == 23 )
	{

			print "MOdifying the xchr sample file for impute2\n";
			open(XCHR,"$dirtemp/$rounded/23/snps_chr23.fam")or die "no file exists $dirtemp/$rounded/23/snps_chr23.fam\n";
			while(<XCHR>)
			{
				chomp($_);
				@array = split(" ",$_);
				$xchr{$array[1]} = $array[4];
			}
			close(XCHR);
			open(XCHR,"$dirtemp/$rounded/23/snps_chr23.sample")or die "no file exists $dirtemp/$rounded/23/snps_chr23.sample\n";
			open(WRXCHR,">$dirtemp/$rounded/23/snps_chr23_1.sample")or die "unable to write file $dirtemp/$rounded/23/snps_chr23_1.sample\n";
			$line = <XCHR>;
			chomp($line);
			print WRXCHR $line." sex\n";
			$line = <XCHR>;
			chomp($line);
			print WRXCHR $line." D\n";
			while(<XCHR>)
			{
					chomp($_);
				@array = split(" ",$_);
				if(!exists($xchr{$array[1]}))
				{
					die "plink file doesn't match with shapeit program output sample file\n";
				}
				print WRXCHR "$_ $xchr{$array[1]}\n";
			}
			system("mv $dirtemp/$rounded/23/snps_chr23_1.sample $dirtemp/$rounded/23/snps_chr23.sample");
			system("cp $dirtemp/$rounded/23/snps_chr23.sample $dirtemp/$rounded/23/final.sample");
			undef %xchr;
			close(XCHR);
			close(WRXCHR);
		
	}
	
	#@check_chr=(9,10,11,12,13,14,15,16,17,18,19,20,21,22,23);
	#@check_chr=(22,23);
	#creating the array job file for the impute
	open(ARRAY_IMPUTE,">$dirtemp/$rounded/ArrayJob_file_impute") or die "unable to create file $dirtemp/$rounded/ArrayJob_file_impute\n";
	open(GUNZIP_IMPUTE_WRBUFF,">$dirtemp/$rounded/Gunzip_file_impute")or die "unable to write the file Gunzip_file_shapeit\n";
	#calculating window sizes for all chrs
	#die "test @check_chr\n";
	for($i=0;$i<@check_chr;$i++)
	{
		print "\n\n\n\n\nDEALING WITH CHR $check_chr[$i]\n\n\n\n";
		open(BIM,"gunzip -c $dirtemp/$rounded/$check_chr[$i]/snps_chr$check_chr[$i].haps.gz|") or die "$dirtemp/$rounded/$check_chr[$i]/snps_chr$check_chr[$i].haps.gz file not exists\n";
		$line = <BIM>;
		@array = split(" ",$line);
		$start = $array[2];
		while($line = <BIM>)
		{
			$line1 = $line;
		}
		@array = split(" ",$line1);
		$stop = $array[2];
		$num_windows = ($stop-$start+1)/$impute_window;
		$rem = ($stop-$start+1)%$impute_window;
		$num_windows =~ s/\.\d+//g;
		if($rem != 0)
		{
				$num_windows =$num_windows+1;
		}
		print "INDATA START: $start STOP: $stop numwindows :  $num_windows\n";
		#creating windows start and stop
		for($j=0;$j<$num_windows;$j++)
		{
			$count_snp_window_indata[$j] = 0;
			$count_snp_window_reference[$j] = 0;
			if($j ==0)
			{
				$start_window[$j] = $start;
				$stop_window[$j] = $start_window[$j]+ $impute_window -1;
			}
			else
			{
				$start_window[$j] = $stop_window[$j-1]+1;
				$stop_window[$j] = $start_window[$j]+ $impute_window -1;
			}
		}
		#print "@start_window\n@stop_window\n";
		#counting the number of input data markers in each window
		open(BIM,"gunzip -c $dirtemp/$rounded/$check_chr[$i]/snps_chr$check_chr[$i].haps.gz|") or die "$dirtemp/$rounded/$check_chr[$i]/snps_chr$check_chr[$i].haps.gz file not exists\n";
		$j = 0;
		while($line = <BIM>)
		{
			@array = split(" ",$line);
			if($array[2] >= $start_window[$j] && $array[2] <= $stop_window[$j])
			{
				$count_snp_window_indata[$j]++;
			}	
			else
			{
				$j++;
				if($array[2] >= $start_window[$j] && $array[2] <= $stop_window[$j])
				{
					$count_snp_window_indata[$j]++;
				}
			}
		}
		#print "$num\n";
		#counting the number of reference data marers in each window
		if($check_chr[$i] ==23)
		{
			$file = $ref_keyword."_chrX_nonPAR_impute.legend.gz";
			open(BIM,"gunzip -c $impute_ref/$file|") or die "no file found $impute_ref/$file\n";
		}
		else
		{
			$file = $ref_keyword."_chr$check_chr[$i]".'_impute.legend.gz';;
			open(BIM,"gunzip -c $impute_ref/$file|") or die "no file found $impute_ref/$file\n";
		}
		$line = <BIM>;
		$j = 0;
		#print $line."\n";
		$k = 0;
		while($line = <BIM>)
		{
			@array = split(" ",$line);
			#start: storing starting value of the chr in the reference
			if($k == 0)
			{
				$start_chr_ref = $array[1];
			}
			$stop_chr_ref = $array[1];
			$k++;
			#end: storing starting value of the chr in the reference
			if($array[1] < $start_window[0] || $array[1] > $stop_window[@stop_window -1])
			{

			}	
			elsif($array[1] <= $stop_window[$j] && $array[1] >= $start_window[$j])
			{
				$count_snp_window_reference[$j]++;
			}
			else
			{
				$j++;
				if($array[1] >= $start_window[$j] && $array[1] <= $stop_window[$j])
				{
					$count_snp_window_reference[$j]++;
				}
			}
		}
		print "\n\n raw counts of windows\n";
		for($j=0;$j<@count_snp_window_indata;$j++)
			{
					print "Start : $start_window[$j] Stop : $stop_window[$j] Data : $count_snp_window_indata[$j] Reference : $count_snp_window_reference[$j]\n";
		}
		#die;
		#creating zeros for windows count zero
		for($j=0;$j<@count_snp_window_indata;$j++)
		{
			#print "Start : $start_window[$j] Stop : $stop_window[$j] Data : $count_snp_window_indata[$j] Reference : $count_snp_window_reference[$j]\n";
			#checking for minimum 200 count snps
			# if($chr_start_input eq "YES")
			# {
				# $cutoff=5;
			# }
			# else
			# {
				# $cutoff = 5;
			#	$cutoff = 200;
			# }
			if($count_snp_window_indata[$j] < $cutoff ||  $count_snp_window_reference[$j] < $cutoff)
			{
					$stop_window[$j]  = 0;
					$start_window[$j+1] = 0;
					if($j == @count_snp_window_indata -1)
					{
						$start_window[$j] = 0;
						$stop_window[$j-1]  = 0;
					}
			}
		}
		print "\n\n\n\n\n\n";
		#print "\n\n temp counts of windows\n";
		for($j=0;$j<@count_snp_window_indata;$j++)
			{
			#		print "Start : $start_window[$j] Stop : $stop_window[$j] Data : $count_snp_window_indata[$j] Reference : $count_snp_window_reference[$j]\n";
			}

		$k = -1;
		#$start_window_new[0] = $start_window[0];
		#merging windows based on zeros
		for($j=0;$j<@count_snp_window_indata;$j++)
		{
			if($start_window[$j] != 0 && $stop_window[$j] != 0)
			{
				$k++;
				$start_window_new[$k] = $start_window[$j];
				$stop_window_new[$k] = $stop_window[$j];
				$count_snp_window_indata_new[$k] = $count_snp_window_indata[$j];
				$count_snp_window_reference_new[$k] = $count_snp_window_reference[$j];
			}
			elsif($start_window[$j] ==0)
			{
							$stop_window_new[$k] = $stop_window[$j];
							$count_snp_window_indata_new[$k] =$count_snp_window_indata_new[$k]+$count_snp_window_indata[$j];
							$count_snp_window_reference_new[$k] =$count_snp_window_reference_new[$k]+$count_snp_window_reference[$j];
			}
			else
			{
				$k++;
				$start_window_new[$k] = $start_window[$j];
				$count_snp_window_indata_new[$k] =$count_snp_window_indata[$j];
				$count_snp_window_reference_new[$k] =$count_snp_window_reference[$j]; 
			} 
		}
		#writing parameters in to array job impute file
		#start:extending windows start and stop according to reference
		if($chr_start_input eq "YES")
		{	
			$start_window_new[0]= $start-$small_region_extn_start;
			$stop_window_new[@stop_window_new -1] = $stop+$small_region_extn_stop; 
		}
		else
		{
			$start_window_new[0]= $start_chr_ref;
			$stop_window_new[@stop_window_new -1] = $stop_chr_ref; 
		}
		#start:extending windows start and stop according to reference
		print "\n\n\n\n\n\n";
		print "\n finalized windows and counts\n";
		
		#opening the inputfile
		open(BIM,"gunzip -c $dirtemp/$rounded/$check_chr[$i]/snps_chr$check_chr[$i].haps.gz|") or die "$dirtemp/$rounded/$check_chr[$i]/snps_chr$check_chr[$i].haps.gz file not exists\n";	
		$line = <BIM>;
		@array = split(" ",$line);
		undef(@edge);
		#checking for number of markers in the stop edge and if needed extended
		for($j=0;$j<=$k;$j++)
		{
			#print "Start : $start_window_new[$j] Stop : $stop_window_new[$j] Data : $count_snp_window_indata_new[$j] Reference : $count_snp_window_reference_new[$j]\n";
			if($j == $k)
			{
				$edge[$j] = $impute_edge*1000;
			}
			else
			{
				#actual start of the edge
				$start_ed=$stop_window_new[$j];
				#actual stop of the edge
				$stop_ed=$stop_window_new[$j]+$impute_edge*1000;
				#fake stop of the edge
				$temp_stop_ed=0;
				$counter=0;
				$flag=0;
				while($flag<1)
				{
					#counting the number of markers if position greater than edge start
					if($array[2] >= $start_ed )
					{
						$counter++;
						$temp_stop_ed =$array[2]; 	
					}
					#checking if the counter exceeds the limit
					if($counter > $edge_cutoff)
					{
						$flag=1;
						if($temp_stop_ed > $stop_ed)
						{
							$edge[$j] = $temp_stop_ed -$stop_window_new[$j];
						}
						else
						{
							$edge[$j] = $impute_edge*1000;
						}		
					}
					$line = <BIM>;
					if($line !~ /\w/)
					{
						die "all the lines in the input file are already read but the edge_cutoff $edge_cutoff notmet\n";
					}
					@array = split(" ",$line);
				}
			}
			#print "Edge : $edge[$j] $start_ed $stop_ed $temp_stop_ed\n";		
		}
		#checking the edges for minimum cutoff
		
		#opening the inputfile in the reverse order
		open(BIM,"gunzip -c $dirtemp/$rounded/$check_chr[$i]/snps_chr$check_chr[$i].haps.gz|tac|") or die "$dirtemp/$rounded/$check_chr[$i]/snps_chr$check_chr[$i].haps.gz file not exists\n";	
		$line = <BIM>;
		@array = split(" ",$line);
		#checking for number of markers in the start  edge and if needed extended
		for($j=$k;$j>=0;$j--)
		{
			#print "Edge : $edge[$j] Start : $start_window_new[$j] Stop : $stop_window_new[$j] Data : $count_snp_window_indata_new[$j] Reference : $count_snp_window_reference_new[$j]\n";
			if($j != 0)
			{
				#actual start of the edge
				$start_ed=$start_window_new[$j];
				#actual stop of the edge
				$stop_ed=$start_window_new[$j]-$impute_edge*1000;
				#fake stop of the edge
				$temp_stop_ed=0;
				$counter=0;
				$flag=0;
				while($flag<1)
				{
					#counting the number of markers if position lesser than edge start (reverse)
					if($array[2] < $start_ed )
					{
						$counter++;
						$temp_stop_ed =$array[2]; 	
					}
					#checking if the counter exceeds the limit
					if($counter > $edge_cutoff)
					{
						$flag=1;
						if($temp_stop_ed < $stop_ed)
						{
							if($start_window_new[$j]-$temp_stop_ed > $edge[$j])
							{	
								$edge[$j] = $start_window_new[$j]-$temp_stop_ed; 
							}
						}		
					}
					$line = <BIM>;
					if($line !~ /\w/)
					{
						die "all the lines in the input file are already read but the edge_cutoff $edge_cutoff notmet\n";
					}
					@array = split(" ",$line);
				}
			}
			$edge[$j]=int($edge[$j]/1000);
			if($edge[$j] > 2000)
			{
				$edge[$j] =2000;
			}
			#print "Edge : $edge[$j] $start_ed $stop_ed $temp_stop_ed\n";
			#rounding the edge
		}
		
		for($j=0;$j<=$k;$j++)
		{
			print "Start : $start_window_new[$j] Stop : $stop_window_new[$j] Data : $count_snp_window_indata_new[$j] Reference : $count_snp_window_reference_new[$j]\n";
			#if window is greater than 5 mb attach -allow_large_regions
			$length_window = $stop_window_new[$j] - $start_window_new[$j] +$edge[$j]*2*1000;
			print "$length_window\n";
			if($length_window > 5000000)
			{
				$option_val = '-use_prephased_g -allow_large_regions';
			}
			else
			{
				$option_val = '-use_prephased_g ';
			}
			if($check_chr[$i] != 23)
			{
				$map = "genetic_map_chr$check_chr[$i]"."_combined_b37.txt";
				$legend = $ref_keyword."_chr$check_chr[$i]"."_impute.legend.gz";
				$hap = $ref_keyword."_chr$check_chr[$i]"."_impute.hap.gz";
				if(uc($pbs) ne "YES")
				{
					#print ARRAY_IMPUTE "$option_val -m $impute_ref/$map -h $impute_ref/$hap -l $impute_ref/$legend -int $start_window_new[$j] $stop_window_new[$j] -Ne 20000  -buffer $impute_edge -known_haps_g $dirtemp/$rounded/$check_chr[$i]/snps_chr$check_chr[$i].haps.gz -o $dirtemp/$rounded/$check_chr[$i]/impute_out_chr$check_chr[$i].window$j\n";
					print ARRAY_IMPUTE "$option_val -m $impute_ref/$map -h $impute_ref/$hap -l $impute_ref/$legend -int $start_window_new[$j] $stop_window_new[$j] -Ne 20000  -buffer $edge[$j] -known_haps_g $dirtemp/$rounded/$check_chr[$i]/snps_chr$check_chr[$i].haps.gz -o impute_out_chr$check_chr[$i].window$j\n";
					#print GUNZIP_IMPUTE_WRBUFF "gzip $dirtemp/$rounded/$check_chr[$i]/impute_out_chr$check_chr[$i].window$j*\n";
					print GUNZIP_IMPUTE_WRBUFF "$dirtemp/$rounded/$check_chr[$i]/\n";
				}
				else
				{
					#print ARRAY_IMPUTE "$option_val -m $impute_ref/$map -h $impute_ref/$hap -l $impute_ref/$legend -int $start_window_new[$j] $stop_window_new[$j] -Ne 20000  -buffer $impute_edge -known_haps_g $dirtemp/$rounded/$check_chr[$i]/snps_chr$check_chr[$i].haps.gz -o $dirtemp/$rounded/$check_chr[$i]/impute_out_chr$check_chr[$i].window$j\n";
					print ARRAY_IMPUTE "$option_val -m $impute_ref/$map -h $impute_ref/$hap -l $impute_ref/$legend -int $start_window_new[$j] $stop_window_new[$j] -Ne 20000  -buffer $edge[$j] -known_haps_g $dirtemp/$rounded/$check_chr[$i]/snps_chr$check_chr[$i].haps.gz -o $dirtemp/$rounded/$check_chr[$i]/impute_out_chr$check_chr[$i].window$j\n";
					#print GUNZIP_IMPUTE_WRBUFF "gzip $dirtemp/$rounded/$check_chr[$i]/impute_out_chr$check_chr[$i].window$j*\n";
					print GUNZIP_IMPUTE_WRBUFF "$dirtemp/$rounded/$check_chr[$i]/impute_out_chr$check_chr[$i].window$j\n";
				
				}	
			}
			else
			{
				$map = "genetic_map_chrX_nonPAR_combined_b37.txt";
				$legend = $ref_keyword."_chrX_nonPAR_impute.legend.gz";
				$hap = $ref_keyword."_chrX_nonPAR_impute.hap.gz";
				if(uc($pbs) ne "YES")
				{			
					#$option_val =~ s/-use_prephased_g//g;
					#print ARRAY_IMPUTE "$option_val -chrX -m $impute_ref/$map -h $impute_ref/$hap -l $impute_ref/$legend -int $start_window_new[$j] $stop_window_new[$j] -Ne 20000  -buffer $impute_edge -known_haps_g $dirtemp/$rounded/$check_chr[$i]/snps_chr$check_chr[$i].haps.gz -sample_known_haps_g $dirtemp/$rounded/$check_chr[$i]/snps_chr$check_chr[$i].sample -o $dirtemp/$rounded/$check_chr[$i]/impute_out_chr$check_chr[$i].window$j\n";
					print ARRAY_IMPUTE "$option_val -chrX -m $impute_ref/$map -h $impute_ref/$hap -l $impute_ref/$legend -int $start_window_new[$j] $stop_window_new[$j] -Ne 20000  -buffer $edge[$j] -known_haps_g $dirtemp/$rounded/$check_chr[$i]/snps_chr$check_chr[$i].haps.gz -sample_known_haps_g $dirtemp/$rounded/$check_chr[$i]/snps_chr$check_chr[$i].sample -o impute_out_chr$check_chr[$i].window$j\n";
					#print GUNZIP_IMPUTE_WRBUFF "gzip $dirtemp/$rounded/$check_chr[$i]/impute_out_chr$check_chr[$i].window$j*\n";
					print GUNZIP_IMPUTE_WRBUFF "$dirtemp/$rounded/$check_chr[$i]/\n";
				}
				else
				{
					#$option_val =~ s/-use_prephased_g//g;
					#print ARRAY_IMPUTE "$option_val -chrX -m $impute_ref/$map -h $impute_ref/$hap -l $impute_ref/$legend -int $start_window_new[$j] $stop_window_new[$j] -Ne 20000  -buffer $impute_edge -known_haps_g $dirtemp/$rounded/$check_chr[$i]/snps_chr$check_chr[$i].haps.gz -sample_known_haps_g $dirtemp/$rounded/$check_chr[$i]/snps_chr$check_chr[$i].sample -o $dirtemp/$rounded/$check_chr[$i]/impute_out_chr$check_chr[$i].window$j\n";
					print ARRAY_IMPUTE "$option_val -chrX -m $impute_ref/$map -h $impute_ref/$hap -l $impute_ref/$legend -int $start_window_new[$j] $stop_window_new[$j] -Ne 20000  -buffer $edge[$j] -known_haps_g $dirtemp/$rounded/$check_chr[$i]/snps_chr$check_chr[$i].haps.gz -sample_known_haps_g $dirtemp/$rounded/$check_chr[$i]/snps_chr$check_chr[$i].sample -o $dirtemp/$rounded/$check_chr[$i]/impute_out_chr$check_chr[$i].window$j\n";
					#print GUNZIP_IMPUTE_WRBUFF "gzip $dirtemp/$rounded/$check_chr[$i]/impute_out_chr$check_chr[$i].window$j*\n";
					print GUNZIP_IMPUTE_WRBUFF "$dirtemp/$rounded/$check_chr[$i]/impute_out_chr$check_chr[$i].window$j\n";
				
				}
			}
		}
		undef(@start_window);
		undef(@stop_window);
		undef(@start_window_new);
		undef(@stop_window_new);
		undef(@array);
		undef(@count_snp_window_indata_new);
		undef(@count_snp_window_indata);
		undef(@count_snp_window_reference_new);
		undef(@count_snp_window_reference);
	}

	#submit the impute jobs
	#open(ARRAY_IMPUTE,"$dir/bin/ArrayJob_impute.csh") or die "no file exists ArrayJob_impute.csh\n";
	#@impute = <ARRAY_IMPUTE>;
	#$impute =join("",@impute);
	#@impute =();
	#@impute = split('zzz',$impute);
	system("mkdir $dirtemp/$rounded/impute_logfiles_sungrid");
	$input_impute_jobids="ArrayJob_file_impute";
	$input_impute_jobids_gunzip="Gunzip_file_impute";
	$counter_jobs = 2; #fake number
}
else
{
	open(RESTART,"$dirtemp/$rounded/ArrayJob_file_impute")or die " no file found $dirtemp/$rounded/ArrayJob_file_shapeit\n";
	open(WRRESTART,">$dirtemp/$rounded/ArrayJob_file_impute_restart")or die " not able to write $dirtemp/$rounded/ArrayJob_file_shapeit_restart\n";
	open(RESTART_GUNZIP,"$dirtemp/$rounded/Gunzip_file_impute")or die "no file found Gunzip_file_shapeit\n";
	open(WRRESTART_GUNZIP,">$dirtemp/$rounded/Gunzip_file_impute_restart")or die "unable to write the file Gunzip_file_shapeit_restart\n";
	$counter_jobs = 0;
	while($restart=<RESTART>)
	{
		chomp($restart);
		
		$restart_gz = <RESTART_GUNZIP>;
		chomp($restart_gz);
		@array=split(" ",$restart);
		@array1 = split(/\//,$array[@array-3]);
		$array1[@array1-1] = $array[@array-1];
		$array[@array-1] = join('/',@array1);
		$chr = $array1[@array1-2];
		if(!(-e "$array[@array-1].gz"))
		{
			print WRRESTART $restart."\n";
			print WRRESTART_GUNZIP  $restart_gz."\n";
			$counter_jobs++;
		}
	}
	close(RESTART);
	close(WRRESTART);
	$input_impute_jobids = "ArrayJob_file_impute_restart";
	$input_impute_jobids_gunzip="Gunzip_file_impute_restart";
}

#should remove this
#$input_impute_jobids="ArrayJob_file_impute";
#$input_impute_jobids_gunzip="Gunzip_file_impute";
#$counter_jobs = 2; #fake number
#print "$counter_jobs\n";
print "wc -l $dirtemp/$rounded/$input_impute_jobids\n";
$count_impute_jobs = `wc -l $dirtemp/$rounded/$input_impute_jobids`;
$count_impute_jobs =~  s/ .*//g;
chomp($count_impute_jobs);

#$impute =$impute[0].$count_impute_jobs.$impute[1]."$dirtemp/$rounded/impute_logfiles_sungrid".$impute[2]."$dirtemp/$rounded/impute_logfiles_sungrid".$impute[3]."$dirtemp/$rounded/ArrayJob_file_impute".$impute[4]."$IMPUTE ".$impute[5];
open(ARRAY_SHAPEIT,">$dirtemp/$rounded/ArrayJob_impute.csh") or die "unable to create the array job file\n";
if(-e "$dirtemp/$rounded/impute_check_jobs")
{
	system("rm $dirtemp/$rounded/impute_check_jobs");
	
}
#die;
system("touch $dirtemp/$rounded/impute_check_jobs");
if(uc($pbs) ne "YES")
{
	$com = '#!';
	print ARRAY_SHAPEIT "$com $SH\n";
	$com = '#$';
	print ARRAY_SHAPEIT "$com -q $impute_queue\n";
	print ARRAY_SHAPEIT "$com -l h_vmem=$impute_mem\n";
	print ARRAY_SHAPEIT "$com -t 1-$count_impute_jobs:1\n";
	print ARRAY_SHAPEIT "$com -l loc2tmp=$localtempspace_impute\n";
	print ARRAY_SHAPEIT "$com -M $email\n";
	print ARRAY_SHAPEIT "$com -m a\n";
	print ARRAY_SHAPEIT "$com -V\n";
	print ARRAY_SHAPEIT "$com -cwd\n";
	print ARRAY_SHAPEIT "$com -e $dirtemp/$rounded/impute_logfiles_sungrid\n";
	print ARRAY_SHAPEIT "$com -o $dirtemp/$rounded/impute_logfiles_sungrid\n";
	#$temp = 'tmp=/local2/tmp/`expr $RANDOM \* $RANDOM`';
	#print ARRAY_SHAPEIT "$temp\n";
	#$temp = 'mkdir $tmp';
	print ARRAY_SHAPEIT "$com -notify\n";
	$temp = 'tmp='.$local_temp.'/'.$username.'/`expr $RANDOM \* $RANDOM`';
	print ARRAY_SHAPEIT "date\n";
	print ARRAY_SHAPEIT "$temp\n";
	print ARRAY_SHAPEIT 'cleanup () {'."\n";
	print ARRAY_SHAPEIT '/bin/rm -rf $tmp'."\n";
	print ARRAY_SHAPEIT '}'."\n";
	print ARRAY_SHAPEIT "trap 'cleanup' USR1 USR2 EXIT\n";
	$temp = 'mkdir -p $tmp';
	print ARRAY_SHAPEIT "$temp\n";
	$temp = 'cd $tmp';
	print ARRAY_SHAPEIT "$temp\n";
	print ARRAY_SHAPEIT 't1=`pwd`'."\n";
	print ARRAY_SHAPEIT 't2=`uname -n`'."\n";
	print ARRAY_SHAPEIT 't3="$t1 $t2"'."\n";
	print ARRAY_SHAPEIT 'echo $t3 >> '."$dirtemp/$rounded/impute_system\n";
	$temp = 'k=`cat  '."$dirtemp/$rounded/$input_impute_jobids".' |head -$SGE_TASK_ID |tail -1`';
	print ARRAY_SHAPEIT "$temp\n";
	$temp = "$IMPUTE ".'$k -seed 123456789 '."\n";
	print ARRAY_SHAPEIT "$temp\n";
	#$temp = '$k1'."\n";
	$temp = 'gzip impute_out_*';
	print ARRAY_SHAPEIT "$temp\n";
	print ARRAY_SHAPEIT "wait\n";
	$temp = 'k1'.'=`cat  '."$dirtemp/$rounded/$input_impute_jobids_gunzip".' |head -$SGE_TASK_ID |tail -1`';
	print ARRAY_SHAPEIT "$temp\n";
	$temp = 'mv impute_out_*.gz $k1';
	print ARRAY_SHAPEIT "$temp\n";
	$temp = 'rm -rf $tmp';
	print ARRAY_SHAPEIT "$temp\n";
	#$temp = "cp $dirtemp/$rounded/ArrayJob_file_shapeit ".'`cat  '."$dirtemp/$rounded/$input_impute_jobids_gunzip".' |head -$SGE_TASK_ID |tail -1`'."/waiting.txt\n";
	$temp = 'echo $SGE_TASK_ID >>'."$dirtemp/$rounded/impute_check_jobs\n";
	print ARRAY_SHAPEIT "$temp\n";
	print ARRAY_SHAPEIT "date\n";
}
else
{
	$com = '#!';
	print ARRAY_SHAPEIT "$com $SH\n";
	$com = '#PBS';
	print ARRAY_SHAPEIT "$com -l walltime=10:05:00\n";
	print ARRAY_SHAPEIT "$com -l nodes=1:ppn=1\n";
	print ARRAY_SHAPEIT "$com -t 1-$count_impute_jobs\n";
	print ARRAY_SHAPEIT "$com -M $email\n";
	print ARRAY_SHAPEIT "$com -m a\n";
	print ARRAY_SHAPEIT "$com -A normal\n";
	print ARRAY_SHAPEIT "$com -V\n";
	print ARRAY_SHAPEIT "$com -A bf0\n";
	print ARRAY_SHAPEIT "$com -e $dirtemp/$rounded/impute_logfiles_sungrid\n";
	print ARRAY_SHAPEIT "$com -o $dirtemp/$rounded/impute_logfiles_sungrid\n";
	print ARRAY_SHAPEIT "date\n";
	#print ARRAY_SHAPEIT  'kk1=`echo ${PBS_ARRAYID}|$PERL -e \'$k=<STDIN>;chomp($k);if($k =~ m/-/){@a=split("-",$k);print $a[1]}else{print $k}\'`'."\n";
	print ARRAY_SHAPEIT 'echo ${PBS_ARRAYID}'."\n";
	$temp = "$IMPUTE ".'`cat  '."$dirtemp/$rounded/$input_impute_jobids".' |head -${PBS_ARRAYID} |tail -1`'."\n";
	print ARRAY_SHAPEIT "$temp\n";
	$temp='gzip '.'`cat  '."$dirtemp/$rounded/$input_impute_jobids_gunzip".' |head -${PBS_ARRAYID} |tail -1`'.'*';
	print ARRAY_SHAPEIT "$temp\n";
	$temp = 'echo ${PBS_ARRAYID} >>'."$dirtemp/$rounded/impute_check_jobs\n";
	print ARRAY_SHAPEIT "$temp\n";
	print ARRAY_SHAPEIT "date\n";
}	
#print ARRAY_SHAPEIT $impute;
close(ARRAY_SHAPEIT);
#close(ARRAY_IMPUTE);

#die;
	if($counter_jobs >0)
	{
		if(uc($pbs) ne "YES")
		{
			#submitting and storing the job id
			system("$QSUB $dirtemp/$rounded/ArrayJob_impute.csh &> $dirtemp/$rounded/jobid_impute");
			
			##readin job id from submit_shapeit
			open(ARRAY_IMPUTE,"$dirtemp/$rounded/jobid_impute") or die "unable to open file $dirtemp/$rounded/jobid_impute\n";
			$impute = <ARRAY_IMPUTE>;
			print "$impute\n";
			@impute =split(" ",$impute);
			@impute1 =split(/\./,$impute[2]);
			print "JOB ID $impute1[0]\n";
			$job_id_imputeit = $impute1[0];
			if(-e "$dirtemp/$rounded/waiting.txt")
			{
					system("rm $dirtemp/$rounded/waiting.txt");
			}
		}
		else
		{
			system(" $QSUB $dirtemp/$rounded/ArrayJob_impute.csh &> $dirtemp/$rounded/jobid_impute");
				#readin job id from submit_shapeit
			open(ARRAY_IMPUTE,"$dirtemp/$rounded/jobid_impute") or die "unable to open file $dirtemp/$rounded/jobid_impute\n";
			$impute = <ARRAY_IMPUTE>;
			print "$impute\n";
			@impute1 =split(/\./,$impute);
			#$shapeit1[0]=~ s/\[\]//g;
			print "JOB ID $impute1[0]\n";
			$job_id_imputeit = $impute1[0];
		}
		if(-e "$dirtemp/$rounded/waiting.txt")
		{
			system("rm $dirtemp/$rounded/waiting.txt");
		}
		if(uc($pbs) ne "YES")
		{
			open(ARRAY_SHAPEIT,">$dirtemp/$rounded/ArrayJob_shapeit_wait.csh") or die "unable to create the array job wait file shape it \n";
			print ARRAY_SHAPEIT '#! '."$SH\n";
			print ARRAY_SHAPEIT '#$ -q 1-hour'."\n";
			print ARRAY_SHAPEIT '#$ -l h_vmem=2G'."\n";
			print ARRAY_SHAPEIT '#$ -M '."$email\n";
			print ARRAY_SHAPEIT '#$ -m a'."\n";
			print ARRAY_SHAPEIT '#$ -V'."\n";
			print ARRAY_SHAPEIT '#$ -cwd'."\n";
			$com = '#$';
			print ARRAY_SHAPEIT "$com -e $dirtemp/$rounded/\n";
			print ARRAY_SHAPEIT "$com -o $dirtemp/$rounded/\n";
			
			print ARRAY_SHAPEIT "cp $dirtemp/$rounded/jobid_impute $dirtemp/$rounded/waiting.txt\n";
			$sys = "$QSUB -hold_jid $job_id_imputeit $dirtemp/$rounded/ArrayJob_shapeit_wait.csh\n";
			
			print $sys."\n";
			system($sys);
		}
		else
		{	open(ARRAY_SHAPEIT,">$dirtemp/$rounded/ArrayJob_shapeit_wait.csh") or die "unable to create the array job wait file shape it \n";
			$com = '#!';
			print ARRAY_SHAPEIT "$com $SH\n";
			$com = '#PBS';
			print ARRAY_SHAPEIT "$com -l walltime=01:05:00\n";
			print ARRAY_SHAPEIT "$com -l nodes=1:ppn=1\n";
			print ARRAY_SHAPEIT "$com -M $email\n";
			print ARRAY_SHAPEIT "$com -m a\n";
			print ARRAY_SHAPEIT "$com -A normal\n";
			print ARRAY_SHAPEIT "$com -V\n";
			print ARRAY_SHAPEIT "$com -A bf0\n";
			print ARRAY_SHAPEIT "$com -e $dirtemp/$rounded/\n";
			print ARRAY_SHAPEIT "$com -o $dirtemp/$rounded/\n";
			print ARRAY_SHAPEIT "cp $dirtemp/$rounded/jobid_impute $dirtemp/$rounded/waiting.txt\n";
			$sys = "$QSUB -W depend=afterokarray:$job_id_imputeit $dirtemp/$rounded/ArrayJob_shapeit_wait.csh\n";
			print $sys."\n";
			system($sys);
		
		}		
		$flag = 1;
		while($flag > 0)
		{
				if($flag%100000000 == 0)
				{
						$flag = 1;
						print "waiting for the shapeit array job to complete\n";
				}
				$flag++;
				#if(-e "$dirtemp/$rounded/waiting.txt")
				#$countImpute=`wc -l $dirtemp/$rounded/impute_check_jobs`;
				#chomp($countImpute);
				#@countImpute=split(" ",$countImpute);
				#$countImpute=~ s/ \w+//g;
				#if($countImpute[0] eq $count_impute_jobs)
				if(-e "$dirtemp/$rounded/waiting.txt")
				{
						$flag =0;
				}
		}
		if(-e "$dirtemp/$rounded/waiting.txt")
		{
				system("rm $dirtemp/$rounded/waiting.txt");
		}
}

#removing the directories
#removing all the jobs
#open(SYS,"$dirtemp/$rounded/impute_system") or die "no file exists $dirtemp/$rounded/shapeit_system\n";
#while(<SYS>)
#{
#	chomp($_);
#			#$machine = <SYS>;
#			#chomp($machine);
#	if($_ =~ m/^\/local2\/tmp\//)
#	{
#		@sys = split(" ",$_);
#		if($sys[0] ne "" && $sys[0] =~ m/\w/)
#		{
#			$sys = 'rsh -l '.$username.' '.$sys[1].' "'.'rm -rf '.$sys[0].'"';
#			print "executing $sys\n";
#			system($sys);
#		}
#	}		
#}	
#checking all the impute jobs are successfully completed
undef(@check_chr);

open(ARRAY_IMPUTE,"$dirtemp/$rounded/ArrayJob_file_impute") or die "unable to find file $dirtemp/$rounded/ArrayJob_file_impute\n";
#open(IMPUTE_3_PROB,">$dirtemp/$rounded/Combined_impute_results_3_prob_allchr")  or die "unable to create file $dirtemp/$rounded/Combined_impute_results_3_prob_allchr\n";
$prevchr ="";
#@jobs_failed = ();
$k = 0;
while(<ARRAY_IMPUTE>)
{#
	chomp($_);
	$_ =~ s/\s+$//g;
	undef(@array);
	undef(@array1);
	@array = split(" ",$_);
	@array1 = split(/\//,$array[@array-3]);
	$chr = $array1[@array1-2];
	if(uc($pbs) ne "YES")
	{
		$array1[@array1-1] = $array[@array-1];
		$array[@array-1] = join('/',@array1);
	}
	
	if($prevchr ne $chr)
	{
		push(@check_chr,$chr);
	}

			if(!(-e "$array[@array-1].gz"))
			{
				print "not exists file $array[@array-1].gz\n";
				$k = 1;	
			}
			$count = `gunzip -c $array[@array-1].gz|awk -F " " '{print NF}'|uniq|wc -l`;
			chomp($count);
			#die "$array[@array-1].gz $count\n";
			if($count != 1)
			{
				print "file found but number of columns not equal $array[@array-1].gz\n";
				$k = 2;	
				#push(@jobs_failed,"$array[@array-1].gz");
			}
#	}
	$prevchr =$chr;
}
close(BUFF);
if($k != 0)
{
	die "please see above error\n";
}

#print jobs failed
#if(@jobs_failed > 0)
#{
#	print "here is the list of jobs failed\n";
#	for($x=0;$x<@jobs_failed;$x++)
#	{
#		print "$jobs_failed[$x]\n";
#	}
#	die;
#}
#undef(@jobs_failed);


#$sys = "$PLINK --bfile $dirtemp/$rounded/processed_beagle_input  --transpose --recode --out $dirtemp/$rounded/processed_beagle_input";
#print "$sys\n";
#system($sys);

system("gzip $dirtemp/$rounded/*.tped");

#dealing with ambiguous snps
#checking all the impute jobs are successfully completed

open(ARRAY_IMPUTE,"$dirtemp/$rounded/ArrayJob_file_impute") or die "unable to find file $dirtemp/$rounded/ArrayJob_file_impute\n";
$prevchr ="";
$combined_impute_res = "zcat";
open(IMPUTE_CHECK,">$dirtemp/$rounded/impute_QC") or die "not able to write impute_QC\n";
print IMPUTE_CHECK "CHR MARKER NUM_MISMATCH_SAMP\n";
close(IMPUTE_CHECK);
#$totalnum_markers=0;
$imputeqc_num_markers=0;

#creating tped file for indicator combining the snps in the imputation and ambi
system("zcat $dirtemp/$rounded/processed_beagle_input.tped.gz $dirtemp/$rounded/ambi_hapmap_processed_beagle_input.tped.gz  |sort -k1,1n -k4,4n -T $dirtemp/$rounded/ |gzip > $dirtemp/$rounded/ind.tped.gz");
while(<ARRAY_IMPUTE>)
{
	chomp($_);
	$_ =~ s/\s+$//g;
	undef(@array);
	undef(@array1);
	@array = split(" ",$_);
	#$file = "$array[@array-3]";
	@array1 = split(/\//,$array[@array-3]);
	$chr = $array1[@array1-2];
	if(uc($pbs) ne "YES")
	{
		$array1[@array1-1] = $array[@array-1];
		$file = join('/',@array1);
	}
	else
	{
		$file = $array[@array-1];
	}
	if($chr ne $prevchr && $prevchr ne "")
	{
		
		$sys = "$combined_impute_res|gzip > $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob.gz";
		#die "$sys\n";
		print "$sys\n";
		system($sys);
		#calling subroutine to compare observed with imputed
		&IMPUTE_CHECK("$dirtemp/$rounded",$prevchr);
		#$sys="gunzip -c $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob.gz|awk -F ' ' '{if(\$5!=0)print \$0}' |gzip > $dirtemp/$rounded/$prevchr/Combined_impute_results_4_prob.gz";
		#print $sys."\n";
		#system($sys);
		#system("mv 	$dirtemp/$rounded/$prevchr/Combined_impute_results_4_prob.gz $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob.gz");
		#checking the number of snps matches the reference
		$count_data=`gunzip -c $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob.gz|wc -l`;
		$count_data=~ s/\s+\w+//g;
		if($prevchr ==23)
		{
			$filey= $ref_keyword."_chrX_nonPAR_impute.legend.gz";
		}
		else
		{
			$filey = $ref_keyword."_chr$prevchr".'_impute.legend.gz';;
		}
		$count_ref=`gunzip -c $impute_ref/$filey|wc -l`;
		$count_ref=~ s/\s+\w+//g;
		$count_ref=$count_ref-1;
		
                print "success1 $chr_start_input\n";
		if($count_data != $count_ref)
		{
			print "$prevchr-snps in combined windows $count_data doesn't match snps count in reference $count_ref \n";
			if($chr_start_input ne "YES")
			{
				die;
			}
		}
		#checking done
		print "success2 $chr_start_input\n";	
		$combined_impute_res = "zcat";

		$sys = "$PERL $dir/bin/perl_check_ambi_snp.pl -a $dirtemp/$rounded/ambi_hapmap_processed_beagle_input.tped.gz  -c $prevchr -d $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob.gz -n $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob_ambi_out.gz -m $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob_indels_out.gz";
		print "$sys\n";
		system($sys);
		if(uc($pbs) ne "YES")
                {
			system("gunzip -c $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob_ambi_out.gz|cut -d ' ' -f2- |$JAVA -Xmx3000m -jar $GPROBS |gzip > $dirtemp/$rounded/$prevchr/beagle_r2.gz");
		}
		else
		{
			system("gunzip -c $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob_ambi_out.gz|cut -d ' ' -f2- |$JAVA  -Xmx3000m -jar $GPROBS |gzip > $dirtemp/$rounded/$prevchr/beagle_r2.gz");
		}
		$count_r2=3;
		$count_r2=`gunzip -c $dirtemp/$rounded/$prevchr/beagle_r2.gz|wc -l`;
		$count_r2=~ s/\s+\w+//g;
		if($count_r2 <4)
		{
			die "java did not worked for $dirtemp/$rounded/$prevchr/beagle_r2.gz\n"; 
		}
		#$sys = "$PLINK --bfile $dirtemp/$rounded/processed_beagle_input --chr $prevchr --transpose --recode --out $dirtemp/$rounded/$prevchr/snps_chr$prevchr";
		#system($sys);
		#system("gzip $dirtemp/$rounded/$prevchr/snps_chr$prevchr.tped");
		$sys = "$PERL $dir/bin/perl_create_ind.pl -i $dirtemp/$rounded/ind.tped.gz -a $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob_ambi_out.gz -r $dirtemp/$rounded/$prevchr/beagle_r2.gz -o $dirtemp/$rounded/$prevchr/final.dosage.gz -c $prevchr -m $dirtemp/$rounded/$prevchr/final.map.gz|gzip   > $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob_ind.gz";
		print "$sys\n";
		system($sys);
		#system("rm $dirtemp/$rounded/$prevchr/snps_chr$prevchr.tped.gz $dirtemp/$rounded/$prevchr/snps_chr$prevchr.tfam");
		system("rm $dirtemp/$rounded/$prevchr/impute_out_chr$prevchr.window*");
	}
	$combined_impute_res = "$combined_impute_res  $file.gz";
	#dealing with ambiguous snps
	#die "$file $chr $combined_impute_res\n";
	$prevchr = $chr;
}
#last chromsome
$sys = "$combined_impute_res|gzip > $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob.gz";
#die "$sys\n";
print "$sys\n";
system($sys);
#calling subroutine to compare observed with imputed
&IMPUTE_CHECK("$dirtemp/$rounded",$prevchr);
#$sys="gunzip -c $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob.gz|awk -F ' ' '{if(\$5!=0)print \$0}' |gzip > $dirtemp/$rounded/$prevchr/Combined_impute_results_4_prob.gz";
#print $sys."\n";
#system($sys);
#system("mv 	$dirtemp/$rounded/$prevchr/Combined_impute_results_4_prob.gz $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob.gz");
#$prevchr=23;
#@check_chr=(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23);
$count_data=`gunzip -c $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob.gz|wc -l`;
$count_data=~ s/\s+\w+//g;
if($prevchr ==23)
{
	$filey= $ref_keyword."_chrX_nonPAR_impute.legend.gz";
}
else
{
	$filey = $ref_keyword."_chr$prevchr".'_impute.legend.gz';;
}
$count_ref=`gunzip -c $impute_ref/$filey|wc -l`;
$count_ref=~ s/\s+\w+//g;
$count_ref=$count_ref-1;
if($count_data != $count_ref)
{
	#die "$prevchr-snps in combined windows $count_data doesn't match snps count in reference $count_ref \n";
	 print "$prevchr-snps in combined windows $count_data doesn't match snps count in reference $count_ref \n";
         if($chr_start_input ne "YES")
         {
         	die;
         }

}
$combined_impute_res = "zcat";
$sys = "$PERL $dir/bin/perl_check_ambi_snp.pl -a $dirtemp/$rounded/ambi_hapmap_processed_beagle_input.tped.gz  -c $prevchr -d $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob.gz -n $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob_ambi_out.gz -m $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob_indels_out.gz";
print "$sys\n";
system($sys);
if(uc($pbs) ne "YES")
                {
			system("gunzip -c $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob_ambi_out.gz|cut -d ' ' -f2- |$JAVA -Xmx3000m -jar $GPROBS |gzip > $dirtemp/$rounded/$prevchr/beagle_r2.gz");
		}
		else
		{
			system("gunzip -c $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob_ambi_out.gz|cut -d ' ' -f2- |$JAVA  -Xmx3000m -jar $GPROBS |gzip > $dirtemp/$rounded/$prevchr/beagle_r2.gz");
		}
#system("gunzip -c $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob_ambi_out.gz|cut -d ' ' -f2- |$JAVA -Xmx3000m -jar $GPROBS |gzip > $dirtemp/$rounded/$prevchr/beagle_r2.gz");
		#$sys = "$PLINK --bfile $dirtemp/$rounded/processed_beagle_input --chr $prevchr --transpose --recode --out $dirtemp/$rounded/$prevchr/snps_chr$prevchr";
		#system($sys);
		#system("gzip $dirtemp/$rounded/$prevchr/snps_chr$prevchr.tped");
$sys = "$PERL $dir/bin/perl_create_ind.pl -i $dirtemp/$rounded/ind.tped.gz -a $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob_ambi_out.gz -r $dirtemp/$rounded/$prevchr/beagle_r2.gz -o $dirtemp/$rounded/$prevchr/final.dosage.gz -c $prevchr -m $dirtemp/$rounded/$prevchr/final.map.gz|gzip   > $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob_ind.gz";
print "$sys\n";
system($sys);
		#system("rm $dirtemp/$rounded/$prevchr/snps_chr$prevchr.tped.gz $dirtemp/$rounded/$prevchr/snps_chr$prevchr.tfam");
system("rm $dirtemp/$rounded/$prevchr/impute_out_chr$prevchr.window*");
print "chromsomes present @check_chr\n";
open(IMPUTE_CHECK,"$dirtemp/$rounded/impute_QC") or die "not able to write impute_QC\n";
#print IMPUTE_CHECK "CHR MARKER NUM_MISMATCH_SAMP\n";
$line=<IMPUTE_CHECK>;
$imputeqc_num_markers=0;
while(<IMPUTE_CHECK>)
{
	$imputeqc_num_markers++;
}
close(IMPUTE_CHECK);
# if($imputeqc_num_markers/$totalnum_markers > 0.05)
	# {
		# die "$imputeqc_num_markers of observed markers out of $totalnum_markers got changed by the impute tool.Please look at the file $dirtemp/$rounded/impute_QC\n";
	# }
if(@check_chr <1)
{
	die "no chrs in the array @check_chr\n";
}

#subroutine to compate oberved with impute output
sub IMPUTE_CHECK 
{
 	my($dir_t,$chr) = @_;
#print "$dirtemp,$three_prob,$chr,$input_tped\n";
	open(PROB,"gunzip -c $dir_t/$chr/Combined_impute_results_3_prob.gz |") or die "no file found Combined_impute_results_3_prob.gz\n";
	$temp_ch="'^".$chr." '";
	open(INPUT_CHECK,"gunzip -c $dir_t/processed_beagle_input.tped.gz | grep -P $temp_ch|") or die "no file processed_beagle_input.tped file found\n";
	open(IM_OUT,"|gzip > $dir_t/$chr/tmp_Combined_impute_results_3_prob.gz") or die "not able to write $dir_t/$chr/tmp_Combined_impute_results_3_prob.gz\n";
	open(IMPUTE_CHECK,">>$dir_t/impute_QC")  or die "not able to write impute_QC\n";
	#$prob=<PROB>;
	#@prob=split(" ",$prob);
	#$num_input=0;
	#$num_dos=0;
	#print ++$num_dos." dos\n";
	undef(%monomorphic);
	while($prob=<PROB>)
	{
		chomp($prob);
		@prob=split(" ",$prob);
		#if(!exists($duplicate{$prob[1]." ".length($prob[4])." ".length($prob[3])}))
		#{
		#	$duplicate{$prob[1]." ".length($prob[4])." ".length($prob[3])}=1;
		#	print IM_OUT $prob."\n";
		#}
		if($prob[4] eq "0" && length($prob[3])==1)
		{
			$monomorphic{$prob[1]} =1;
=head		
			$prob1=<PROB>;
			@prob1=split(" ",$prob1);	
			if($prob[1] eq $prob1[1] &&  length($prob1[3])==1 && length($prob1[4])==1)
			{
				if($prob1[4] ne $prob[3])
				{
					$prob[4]=$prob1[4];
				}
				else
				{
					$prob[4]=$prob1[3];
				}
				$prob=join(" ",@prob);
				print IM_OUT $prob."\n";
				
			}
			else
			{
				die "order not equal for monomorphic $prob[1] $prob1[1]\n";  
			}
=cut			
		}
		else
		{
			print IM_OUT $prob."\n";
		}
	}	
	system("mv $dir_t/$chr/tmp_Combined_impute_results_3_prob.gz $dir_t/$chr/Combined_impute_results_3_prob.gz");
	open(PROB,"gunzip -c $dir_t/$chr/Combined_impute_results_3_prob.gz |") or die "no file found Combined_impute_results_3_prob.gz\n";
	open(IM_OUT,"|gzip > $dir_t/$chr/tmp_Combined_impute_results_3_prob.gz") or die "not able to write $dir_t/$chr/tmp_Combined_impute_results_3_prob.gz\n";
	while($input=<INPUT_CHECK>)
	{
		#print ++$num_input." input\n";
		@input=split(" ",$input);
		$prob=<PROB>;
		@prob=split(" ",$prob);
		#die "$input[3] ne $prob[2]\n";
		while($input[1] ne $prob[1])
		{
			print IM_OUT $prob;
			$prob=<PROB>;
			if($prob !~ m/\w+/)
			{
				die "for chr $chr some thing wrong with dosage file input position $input[3] not match with dosage position  $prob[2]\n";
			} 
			#print ++$num_dos." dos\n";
			@prob=split(" ",$prob);	
		}
		#die "sucess\n";
		$prob_ini=shift(@prob);
		$prob_rsid=shift(@prob);
		$prob_pos=shift(@prob);
		$prob_a1=shift(@prob);
		$prob_a2=shift(@prob);
		#if($prob_a2 eq "0")
		#{
		#	$prob_a2=$prob_a1;
		#}
			print IM_OUT "$prob_ini $prob_rsid $prob_pos $prob_a1 $prob_a2";
			$chr=shift(@input);
			$input_rsid=shift(@input);
			shift(@input);
			$input_pos=shift(@input);
			if($input_pos != $prob_pos || $prob_rsid ne $input_rsid)
			{
				die "checking impute output with observed $chr !\nsnp pos or rsid not matching observed rsid $input_rsid observed  pos $input_pos imputed pos $prob_pos imputed rsid $prob_rsid\n";	
			}
			$y=0;
			$num=0;
			
			for($i=0;$i<@input;$i++)
			{
				$a1=$input[$i++];
				$a2=$input[$i];
				$p1=$prob[$y++];
				$p2=$prob[$y++];
				$p3=$prob[$y++];
				if($a1 eq $prob_a1 && $a2  eq $prob_a1 && "$p1 $p2 $p3" ne "1 0 0")
				{
					 print IM_OUT " 1 0 0";
					$num++;
				}
				elsif($a1 eq $prob_a2 && $a2  eq $prob_a2 && "$p1 $p2 $p3" ne "0 0 1")
				{
					print IM_OUT " 0 0 1";
					$num++;
				}
				elsif((($a1 eq $prob_a1 && $a2  eq $prob_a2)|| ($a1 eq $prob_a2 && $a2  eq $prob_a1))&& "$p1 $p2 $p3" ne "0 1 0") 
				{
					print IM_OUT " 0 1 0";
					$num++;
				}
				else
				{
					print IM_OUT " $p1 $p2 $p3";
				}
			}
				print IM_OUT "\n";
				if($num > 0 && !exists($monomorphic{$prob_rsid}))
				{
					print IMPUTE_CHECK "$chr $prob_rsid $num\n";
					#die;
				}
				
		#$prob=<PROB>;
		#@prob=split(" ",$prob);
	}
	while($prob=<PROB>)
	{
		#print ++$num_dos." dos\n";
		print IM_OUT $prob;
	
	}
	undef(%monomorphic);
	close(INPUT_CHECK);
	close(PROB);	
	close(IMPUTE_CHECK);
	close(IM_OUT);
	system("mv $dir_t/$chr/Combined_impute_results_3_prob.gz $dir_t/$chr/ori_Combined_impute_results_3_prob.gz");
	system("mv $dir_t/$chr/tmp_Combined_impute_results_3_prob.gz $dir_t/$chr/Combined_impute_results_3_prob.gz");
}

