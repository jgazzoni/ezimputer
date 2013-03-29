

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
my $shapeit_mem = $config{"SGE_SHAPEIT_MEM"};
my $shapeit_queue = $config{"SGE_SHAPEIT_QUEUE"};
my $impute_mem = $config{"SGE_IMPUTE_MEM"};
my $impute_queue = $config{"SGE_IMPUTE_QUEUE"};
my $ref_keyword = $config{"IMPUTEREF_VERSION"};
my $localtempspace_shapeit = $config{"LOCALTEMP_SHAPEIT"};
my $localtempspace_impute = $config{"LOCALTEMP_IMPUTE"};
my $rounded = $config{"INNER_DIR"};
my $restart_impute = $config{"RESTART"};
my $username = $config{"USERNAME"};
my $shapit_only = $config{"SHAPEITONLY"};
my $local_temp=$config{"LOCALTEMP"};
my $shapeit_states_phase=$config{"SHAPEIT_STATESPHASE"};
my $pbs=$config{"PBS"};
my $pbs_option=$config{"PBS_PARAM"};
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

if($pbs ne "YES")
{
	$shapeit_mem=~ s/\s|\t|\r|\n//g;
	$shapeit_queue=~ s/\s|\t|\r|\n//g;
	$impute_mem=~ s/\s|\t|\r|\n//g;
	$impute_queue=~ s/\s|\t|\r|\n//g;
}
else
{
	
	$pbs_option=~ s/"//g;
	$pbs_option=~ s/\t|\r|\n//g;
}
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
if($pbs ne "YES")
{
	print "SGE_SHAPEIT_MEM: $shapeit_mem\n";
	print "SGE_SHAPEIT_QUEUE: $shapeit_queue\n";
	print "SGE_IMPUTE_MEM: $impute_mem\n";
	print "SGE_IMPUTE_QUEUE: $impute_queue\n";
}
else
{
	@pbs_param=split(/\,/,$pbs_option);
	for($i=0;$i<@pbs_param;$i++)
	{	
	
		print "PBS_PARAM:$pbs_param[$i]\n";
	}
}
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
if($restart_impute ne "POST" && $restart_impute ne "IMPUTE" && $restart_impute ne "SHAPEIT" && $restart_impute ne "NO" && $restart_impute ne "NA")
{
	die "$restart_impute should be equal to NA or NO or POST or IMPUTE or SHAPEIT.Refer manual\n";
}
if($impute_edge != 125)
{
	#die "impute edge should be 125 in kb\n";
}
$dirtemp =~ s/\/$//g;
$impute_ref =~ s/\/$//g;
if($chr_start_input eq "YES" && $small_region_extn_start !~ m/\d/ && $small_region_extn_stop !~ m/\d/)
{
	die "�	SMALL_REGION_EXTN_START and SMALL_REGION_EXTN_STOP should be number as you selected CHR_START_INPUT=YES\n";
}
if($pbs ne "YES" && ($shapeit_mem !~ m/\w/ | $shapeit_queue !~ m/\w/ | $impute_mem !~ m/\w/ | $impute_queue !~ m/\w/))
{
	die "Selected PBS=NO ,so SGE_SHAPEIT_MEM,SGE_SHAPEIT_QUEUE,SGE_IMPUTE_MEM,SGE_IMPUTE_QUEUE parameters cannot be empty\n";
}
if($pbs eq "YES" && $pbs_option !~ m/\w/)
{
	die "Selected PBS=NO ,so PBS_PARAM cannot be empty\n";
}
if($edge_cutoff eq "" | $cutoff eq "" | $chr_start_input eq "" | $shapeit_states_phase eq "" |$local_temp eq "" | $shapit_only eq "" | $username eq "" |$dirtemp eq "" | $tped eq "" | $tfam eq ""  | $impute_ref eq "" | $impute_window eq "" | $impute_edge eq "" | $haps eq "" | $email eq "" )
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
if(($restart_impute eq "NO" || $restart_impute eq "NA" )&& (-d "$dirtemp/$rounded"))
{
	die "Restart option is NA and temp direcoty already exists remove temp directory and retry \n";
}
unless(-d $dirtemp)
{
    system("mkdir -p $dirtemp");
}
$check_ref="$impute_ref/$ref_keyword"."_chr1_impute.legend.gz";
if(!(-e $check_ref))
 {
	die "impute ref directory not found or wrong\n";
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
if(uc($restart_impute) ne "POST")
{
	if(uc($restart_impute) ne "IMPUTE")
	{

		if(uc($restart_impute) ne "SHAPEIT")
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
			#print "chrx_check $chrx_check\n";
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
		}
		if(uc($haps) eq "NA")
		{
			if(uc($restart_impute) ne "SHAPEIT")
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
				$input_shapeit_jobids = "ArrayJob_file_shapeit";
				$input_shapeit_jobids_gunzip="Gunzip_file_shapeit";
			}
			else
			{
				$dirtemp="/data2/bsi/RandD/Arraybased_RND/Easy_imputer_test/temp";
				open(RESTART,"$dirtemp/$rounded/ArrayJob_file_shapeit")or die " no file found $dirtemp/$rounded/ArrayJob_file_shapeit\n";
				open(WRRESTART,">$dirtemp/$rounded/ArrayJob_file_shapeit_restart")or die " not able to write $dirtemp/$rounded/ArrayJob_file_shapeit_restart\n";
				open(RESTART_GUNZIP,"$dirtemp/$rounded/Gunzip_file_shapeit")or die "no file found Gunzip_file_shapeit\n";
				open(WRRESTART_GUNZIP,">$dirtemp/$rounded/Gunzip_file_shapeit_restart")or die "unable to write the file Gunzip_file_shapeit_restart\n";
				$count_shapeit_jobs = 0;
				while($restart=<RESTART>)
				{
						chomp($restart);
						$restart_gz = <RESTART_GUNZIP>;
						chomp($restart_gz);
						@array=split(" ",$restart);
						@array1 = split(/\//,$array[2]);
						$chr = $array1[@array1-2];
						$array[2] =~ s/bim/haps/g;
						if(!(-e "$array[2].gz"))
						{
								print WRRESTART $restart."\n";
								print WRRESTART_GUNZIP  $restart_gz."\n";
								$count_shapeit_jobs++;
						}
				}
				close(RESTART);
				close(WRRESTART);
				$input_shapeit_jobids = "ArrayJob_file_shapeit_restart";
				$input_shapeit_jobids_gunzip="Gunzip_file_shapeit_restart";

			}
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
				$temp = 'k=`cat  '."$dirtemp/$rounded/$input_shapeit_jobids".' |head -$SGE_TASK_ID |tail -1`';
				print ARRAY_SHAPEIT "$temp\n";
				$temp = "$SHAPEIT ".'$k '."\n";
				print ARRAY_SHAPEIT "$temp";
				$temp='gzip snps_chr*.haps';
				print ARRAY_SHAPEIT "$temp\n";
				print ARRAY_SHAPEIT "wait\n";
				$temp = 'k1'.'=`cat  '."$dirtemp/$rounded/$input_shapeit_jobids_gunzip".' |head -$SGE_TASK_ID |tail -1`';
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
				for($p=0;$p<@pbs_param;$p++)
				{
					print ARRAY_SHAPEIT "$com $pbs_param[$p]\n";
				}
				#print ARRAY_SHAPEIT "$com -l walltime=10:05:00\n";
				#print ARRAY_SHAPEIT "$com -l nodes=1:ppn=1\n";
				print ARRAY_SHAPEIT "$com -t 1-$count_shapeit_jobs\n";
				print ARRAY_SHAPEIT "$com -M $email\n";
				print ARRAY_SHAPEIT "$com -m a\n";
				#print ARRAY_SHAPEIT "$com -A normal\n";
				print ARRAY_SHAPEIT "$com -V\n";
				#print ARRAY_SHAPEIT "$com -A bf0\n";
				print ARRAY_SHAPEIT "$com -e $dirtemp/$rounded/shapeit_logfiles_sungrid\n";
				print ARRAY_SHAPEIT "$com -o $dirtemp/$rounded/shapeit_logfiles_sungrid\n";
				$temp = "$SHAPEIT ".'`cat  '."$dirtemp/$rounded/$input_shapeit_jobids".' |head -${PBS_ARRAYID} |tail -1`'."\n";
				print ARRAY_SHAPEIT "$temp\n";
				$temp='gzip '.'`cat  '."$dirtemp/$rounded/$input_shapeit_jobids_gunzip".' |head -${PBS_ARRAYID} |tail -1`'.'snps_chr*.haps';
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
				$com = '#!';
				print ARRAY_SHAPEIT "$com $SH\n";
				$com = '#$';
				print ARRAY_SHAPEIT "$com -q $shapeit_queue\n";
				print ARRAY_SHAPEIT "$com -l h_vmem=$shapeit_mem\n";
				print ARRAY_SHAPEIT "$com -M $email\n";
				print ARRAY_SHAPEIT "$com -m a\n";
				print ARRAY_SHAPEIT "$com -V\n";
				print ARRAY_SHAPEIT "$com -cwd\n";
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
				print ARRAY_SHAPEIT "$com -M $email\n";
				print ARRAY_SHAPEIT "$com -m a\n";
				for($p=0;$p<@pbs_param;$p++)
				{
					print ARRAY_SHAPEIT "$com $pbs_param[$p]\n";
				}
				#print ARRAY_SHAPEIT "$com -A normal\n";
				#print ARRAY_SHAPEIT "$com -A bf0\n";
				#print ARRAY_SHAPEIT "$com -l walltime=01:05:00\n";
				#print ARRAY_SHAPEIT "$com -l nodes=1:ppn=1\n";
				print ARRAY_SHAPEIT "$com -V\n";
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
				if($flag%1000000000  == 0)
					{
							$flag = 1;
							print "waiting for the shapeit array job to complete\n";
					}
				$flag++;

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
			#system("mv $dirtemp/$rounded/$j/snps_chr$j.haps.gz $dirtemp/$rounded/$j/ori_snps_chr$j.haps.gz");
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
		
		for($i=0;$i<@check_chr;$i++)
		{	
			$j = $check_chr[$i];
			$sys="rm $dirtemp/$rounded/SHAPEIT/$j/*"; 
			system($sys);
			$sys="rmdir $dirtemp/$rounded/SHAPEIT/$j/"; 
			system($sys);
		}
		$sys = "rmdir $dirtemp/$rounded/SHAPEIT";
		print "$sys\n";
		system($sys);
		
		if(uc($shapit_only) eq "YES")
		{
			print "SHAPEIT ONLY JOB SO exited see RESULTS IN TEMP FOLDER\n";
			system("mkdir $dirtemp/$rounded/SHAPEIT_OUTPUT");
			system("mv $dirtemp/$rounded/shapeit_jobs.tar.gz $dirtemp/$rounded/SHAPEIT_OUTPUT");
			for($i=0;$i<@check_chr;$i++)
			{	
				$j = $check_chr[$i];
				$sys="rm $dirtemp/$rounded/$j/*";
				system($sys);
				$sys="rmdir $dirtemp/$rounded/$j";
				system($sys);
			}
			system("rm $dirtemp/$rounded/*");
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
		open(RESTART,"$dirtemp/$rounded/ArrayJob_file_impute")or die " no file found $dirtemp/$rounded/ArrayJob_file_impute\n";
		open(WRRESTART,">$dirtemp/$rounded/ArrayJob_file_impute_restart")or die " not able to write $dirtemp/$rounded/ArrayJob_file_impute_restart\n";
		open(RESTART_GUNZIP,"$dirtemp/$rounded/Gunzip_file_impute")or die "no file found Gunzip_file_impute\n";
		open(WRRESTART_GUNZIP,">$dirtemp/$rounded/Gunzip_file_impute_restart")or die "unable to write the file Gunzip_file_shapeit_impute\n";
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
		for($p=0;$p<@pbs_param;$p++)
		{
			print ARRAY_SHAPEIT "$com $pbs_param[$p]\n";
		}
		#print ARRAY_SHAPEIT "$com -l walltime=10:05:00\n";
		#print ARRAY_SHAPEIT "$com -l nodes=1:ppn=1\n";
		print ARRAY_SHAPEIT "$com -t 1-$count_impute_jobs\n";
		print ARRAY_SHAPEIT "$com -M $email\n";
		print ARRAY_SHAPEIT "$com -m a\n";
		#print ARRAY_SHAPEIT "$com -A normal\n";
		print ARRAY_SHAPEIT "$com -V\n";
		#print ARRAY_SHAPEIT "$com -A bf0\n";
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
				$com = '#!';
				print ARRAY_SHAPEIT "$com $SH\n";
				$com = '#$';
				print ARRAY_SHAPEIT "$com -q $impute_queue\n";
				print ARRAY_SHAPEIT "$com -l h_vmem=$impute_mem\n";
				print ARRAY_SHAPEIT "$com -M $email\n";
				print ARRAY_SHAPEIT "$com -m a\n";
				print ARRAY_SHAPEIT "$com -V\n";
				print ARRAY_SHAPEIT "$com -cwd\n";
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
				for($p=0;$p<@pbs_param;$p++)
				{
					print ARRAY_SHAPEIT "$com $pbs_param[$p]\n";
				}
				#print ARRAY_SHAPEIT "$com -l walltime=01:05:00\n";
				#print ARRAY_SHAPEIT "$com -l nodes=1:ppn=1\n";
				print ARRAY_SHAPEIT "$com -M $email\n";
				print ARRAY_SHAPEIT "$com -m a\n";
				#print ARRAY_SHAPEIT "$com -A normal\n";
				print ARRAY_SHAPEIT "$com -V\n";
				#print ARRAY_SHAPEIT "$com -A bf0\n";
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
					if($flag%1000000000  == 0)
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


	system("gzip $dirtemp/$rounded/*.tped");
	system("rm $dirtemp/$rounded/impute_logfiles_sungrid/*");
	system("rmdir $dirtemp/$rounded/impute_logfiles_sungrid/");
}
open(ARRAY_IMPUTE,"$dirtemp/$rounded/ArrayJob_file_impute") or die "unable to find file $dirtemp/$rounded/ArrayJob_file_impute\n";
$prevchr ="";
$combined_impute_res = "zcat";
undef(@check_chr);
#creating tped file for indicator combining the snps in the imputation and ambi
system("zcat $dirtemp/$rounded/processed_beagle_input.tped.gz $dirtemp/$rounded/ambi_hapmap_processed_beagle_input.tped.gz  |sort -k1,1n -k4,4n -T $dirtemp/$rounded/ |gzip > $dirtemp/$rounded/ind.tped.gz");
open(WRSH,">$dirtemp/$rounded/file_post") or die "not able to write file $dirtemp/$rounded/file_post\n"; 
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
		
		#making sure to delete all the files in case of restart
		if(-e "$dirtemp/$rounded/$prevchr/impute_out_chr$prevchr.window0.gz")
		{
				$file_sh="$dirtemp/$rounded/$prevchr/FILE_POST_SUBMIT.sh";
				push(@check_chr,$prevchr);
				print WRSH "$file_sh\n";
				open(WRPOST,">$file_sh") or die "not able to write $file_sh\n";
		
				if(-e "$dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob.gz")
				{	
					system("rm $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob.gz");
				}
				if(-e "$dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob_ambi_out.gz")
				{	
					system("rm $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob_ambi_out.gz");
				}
				if(-e "$dirtemp/$rounded/$prevchr/beagle_r2.gz")
				{	
					system("rm $dirtemp/$rounded/$prevchr/beagle_r2.gz");
				}
				if(-e "$dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob_ind.gz")
				{	
					system("rm $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob_ind.gz");
				}
		}
		if(!(-e "$dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob.gz"))
		{
			print WRPOST "$sys\n";
			$sys="gunzip -c $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob.gz|awk -F ' ' '{if(\$5!=0)print \$0}' |gzip > $dirtemp/$rounded/$prevchr/Combined_impute_results_4_prob.gz";
			print WRPOST "$sys\n";
			$sys = "mv 	$dirtemp/$rounded/$prevchr/Combined_impute_results_4_prob.gz $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob.gz";
			print WRPOST "$sys\n";
		}
		$sys="combine=`gunzip -c $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob.gz|wc -l`";
		print WRPOST "$sys\n";
		if($chr_start_input ne "YES")
		{
			if($prevchr ==23)
			{
				$filey= $ref_keyword."_chrX_nonPAR_impute.legend.gz";
			}
			else
			{
				$filey = $ref_keyword."_chr$prevchr".'_impute.legend.gz';;
			}	
			$sys="count_ref=`gunzip -c $impute_ref/$filey|wc -l`";
			print WRPOST "$sys\n";
			$sys="count_ref=`expr \$count_ref - 1`";
			print WRPOST "$sys\n";
			$sys="if test \$combine -ne \$count_ref\nthen\n     echo \" chromsome$prevchr-snps in combined windows \$combine doesn't match snps count in reference \$count_ref\"\nexit 1\nfi";
			print WRPOST "$sys\n";
		}	
		$combined_impute_res = "zcat";
		$sys = "$PERL $dir/bin/perl_check_ambi_snp.pl -a $dirtemp/$rounded/ambi_hapmap_processed_beagle_input.tped.gz  -c $prevchr -d $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob.gz -n $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob_ambi_out.gz -m $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob_indels_out.gz";
		
		if(!(-e "$dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob_ambi_out.gz"))
		{
			print WRPOST "$sys\n";
		}
		if(!(-e "$dirtemp/$rounded/$prevchr/beagle_r2.gz"))
		{
			if(uc($pbs) ne "YES")
			{
				$sys = "gunzip -c $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob_ambi_out.gz|cut -d ' ' -f2- |$JAVA -Xmx3000m -jar $GPROBS |gzip > $dirtemp/$rounded/$prevchr/beagle_r2.gz";
			}
			else
			{
				$sys = "gunzip -c $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob_ambi_out.gz|cut -d ' ' -f2- |$JAVA  -Xmx3000m -jar $GPROBS |gzip > $dirtemp/$rounded/$prevchr/beagle_r2.gz";
			}
			print WRPOST "$sys\n";
			$sys="combine=3";
			print WRPOST "$sys\n";
			$sys="combine=`gunzip -c $dirtemp/$rounded/$prevchr/beagle_r2.gz|wc -l`";
			print WRPOST "$sys\n";
			$sys="if test \$combine -le 4\nthen\n     echo \" something wrong with generated beagle r2 file : $dirtemp/$rounded/$prevchr/beagle_r2.gz\"\n exit 1\nfi";
			print WRPOST "$sys\n";
		}
		
		$sys = "$PERL $dir/bin/perl_create_ind.pl -i $dirtemp/$rounded/ind.tped.gz -a $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob_ambi_out.gz -r $dirtemp/$rounded/$prevchr/beagle_r2.gz -o $dirtemp/$rounded/$prevchr/final.dosage.gz -c $prevchr -m $dirtemp/$rounded/$prevchr/final.map.gz|gzip   > $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob_ind.gz";
		
		if(!(-e "$dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob_ind.gz"))
		{
			print WRPOST "$sys\n";
		}
		$sys = "rm $dirtemp/$rounded/$prevchr/impute_out_chr$prevchr.window*";
		print WRPOST "$sys\n";
	}
	$combined_impute_res = "$combined_impute_res  $file.gz";
	$prevchr = $chr;
}

#for last chromsome
$sys = "$combined_impute_res|gzip > $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob.gz";
#making sure to delete all the files in case of restart
if(-e "$dirtemp/$rounded/$prevchr/impute_out_chr$prevchr.window0.gz")
{
		$file_sh="$dirtemp/$rounded/$prevchr/FILE_POST_SUBMIT.sh";
		push(@check_chr,$prevchr);
		print WRSH "$file_sh\n";
		open(WRPOST,">$file_sh") or die "not able to write $file_sh\n";
		
		if(-e "$dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob.gz")
		{	
			system("rm $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob.gz");
		}
		if(-e "$dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob_ambi_out.gz")
		{	
			system("rm $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob_ambi_out.gz");
		}
		if(-e "$dirtemp/$rounded/$prevchr/beagle_r2.gz")
		{	
			system("rm $dirtemp/$rounded/$prevchr/beagle_r2.gz");
		}
		if(-e "$dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob_ind.gz")
		{	
			system("rm $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob_ind.gz");
		}
}
if(!(-e "$dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob.gz"))
{
	print WRPOST "$sys\n";
	$sys="gunzip -c $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob.gz|awk -F ' ' '{if(\$5!=0)print \$0}' |gzip > $dirtemp/$rounded/$prevchr/Combined_impute_results_4_prob.gz";
	print WRPOST "$sys\n";
	$sys = "mv 	$dirtemp/$rounded/$prevchr/Combined_impute_results_4_prob.gz $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob.gz";
	print WRPOST "$sys\n";
}
$sys="combine=`gunzip -c $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob.gz|wc -l`";
print WRPOST "$sys\n";
if($chr_start_input ne "YES")
{
	if($prevchr ==23)
	{
		$filey= $ref_keyword."_chrX_nonPAR_impute.legend.gz";
	}
	else
	{
		$filey = $ref_keyword."_chr$prevchr".'_impute.legend.gz';;
	}	
	$sys="count_ref=`gunzip -c $impute_ref/$filey|wc -l`";
	print WRPOST "$sys\n";
	$sys="count_ref=`expr \$count_ref - 1`";
	print WRPOST "$sys\n";
	$sys="if test \$combine -ne \$count_ref\nthen\n     echo \" chromsome$prevchr-snps in combined windows \$combine doesn't match snps count in reference \$count_ref\"\nexit 1\nfi";
	print WRPOST "$sys\n";
}	
$combined_impute_res = "zcat";
$sys = "$PERL $dir/bin/perl_check_ambi_snp.pl -a $dirtemp/$rounded/ambi_hapmap_processed_beagle_input.tped.gz  -c $prevchr -d $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob.gz -n $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob_ambi_out.gz -m $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob_indels_out.gz";
if(!(-e "$dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob_ambi_out.gz"))
{
	print WRPOST "$sys\n";
}
if(!(-e "$dirtemp/$rounded/$prevchr/beagle_r2.gz"))
{
	if(uc($pbs) ne "YES")
	{
		$sys = "gunzip -c $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob_ambi_out.gz|cut -d ' ' -f2- |$JAVA -Xmx3000m -jar $GPROBS |gzip > $dirtemp/$rounded/$prevchr/beagle_r2.gz";
	}
	else
	{
		$sys = "gunzip -c $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob_ambi_out.gz|cut -d ' ' -f2- |$JAVA  -Xmx3000m -jar $GPROBS |gzip > $dirtemp/$rounded/$prevchr/beagle_r2.gz";
	}
	print WRPOST "$sys\n";
	$sys="combine=3";
	print WRPOST "$sys\n";
	$sys="combine=`gunzip -c $dirtemp/$rounded/$prevchr/beagle_r2.gz|wc -l`";
	print WRPOST "$sys\n";
	$sys="if test \$combine -le 4\nthen\n     echo \" something wrong with generated beagle r2 file : $dirtemp/$rounded/$prevchr/beagle_r2.gz\"\n exit 1\nfi";
	print WRPOST "$sys\n";
}

$sys = "$PERL $dir/bin/perl_create_ind.pl -i $dirtemp/$rounded/ind.tped.gz -a $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob_ambi_out.gz -r $dirtemp/$rounded/$prevchr/beagle_r2.gz -o $dirtemp/$rounded/$prevchr/final.dosage.gz -c $prevchr -m $dirtemp/$rounded/$prevchr/final.map.gz|gzip   > $dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob_ind.gz";
if(!(-e "$dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob_ind.gz"))
{
	print WRPOST "$sys\n";
}
$sys = "rm $dirtemp/$rounded/$prevchr/impute_out_chr$prevchr.window*";
print WRPOST "$sys\n";
close(WRPOST);
close(WRSH);
#print "chromsomes present @check_chr\n";
$count_post_jobs=@check_chr;
#running post process for all the chromsomesin the form of array job
system("mkdir $dirtemp/$rounded/post_logfiles_sungrid");
open(ARRAY_SHAPEIT,">$dirtemp/$rounded/ArrayJob_post.csh") or die "unable to create the array job file\n";
if(uc($pbs) ne "YES")
{
	#print ARRAY_SHAPEIT $shapeit;
	$com = '#!';
	print ARRAY_SHAPEIT "$com $SH\n";
	$com = '#$';
	print ARRAY_SHAPEIT "$com -q $shapeit_queue\n";
	print ARRAY_SHAPEIT "$com -l h_vmem=$shapeit_mem\n";
	print ARRAY_SHAPEIT "$com -t 1-$count_post_jobs:1\n";
	print ARRAY_SHAPEIT "$com -M $email\n";
	print ARRAY_SHAPEIT "$com -m a\n";
	print ARRAY_SHAPEIT "$com -V\n";
	print ARRAY_SHAPEIT "$com -cwd\n";
	print ARRAY_SHAPEIT "$com -e $dirtemp/$rounded/post_logfiles_sungrid\n";
	print ARRAY_SHAPEIT "$com -o $dirtemp/$rounded/post_logfiles_sungrid\n";
	
	$temp = 'k=`cat  '."$dirtemp/$rounded/file_post".' |head -$SGE_TASK_ID |tail -1`';
	print ARRAY_SHAPEIT "$temp\n";
	print ARRAY_SHAPEIT "$SH \$k\n";	
}
else
{
	$com = '#!';
	print ARRAY_SHAPEIT "$com $SH\n";
	$com = '#PBS';
	for($p=0;$p<@pbs_param;$p++)
	{
		print ARRAY_SHAPEIT "$com $pbs_param[$p]\n";
	}
	#print ARRAY_SHAPEIT "$com -l walltime=10:05:00\n";
	#print ARRAY_SHAPEIT "$com -l nodes=1:ppn=1\n";
	print ARRAY_SHAPEIT "$com -t 1-$count_post_jobs\n";
	print ARRAY_SHAPEIT "$com -M $email\n";
	print ARRAY_SHAPEIT "$com -m a\n";
	#print ARRAY_SHAPEIT "$com -A normal\n";
	print ARRAY_SHAPEIT "$com -V\n";
	#print ARRAY_SHAPEIT "$com -A bf0\n";
	print ARRAY_SHAPEIT "$com -e $dirtemp/$rounded/post_logfiles_sungrid\n";
	print ARRAY_SHAPEIT "$com -o $dirtemp/$rounded/post_logfiles_sungrid\n";
	$temp = 'k=`cat  '."$dirtemp/$rounded/file_post".' |head -${PBS_ARRAYID} |tail -1`';
	print ARRAY_SHAPEIT "$temp\n";
	print ARRAY_SHAPEIT "$SH \$k\n";
}	

#submitting and storing the job id

if(uc($pbs) ne "YES")
{
	system("$QSUB $dirtemp/$rounded/ArrayJob_post.csh > $dirtemp/$rounded/jobid_shapeit");
	
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
	system(" $QSUB $dirtemp/$rounded/ArrayJob_post.csh > $dirtemp/$rounded/jobid_shapeit");
		#readin job id from submit_shapeit
	open(ARRAY_SHAPEIT,"$dirtemp/$rounded/jobid_shapeit") or die "unable to open file $dirtemp/$rounded/jobid_shapeit\n";
	$shapeit = <ARRAY_SHAPEIT>;
	print "$shapeit\n";
	@shapeit1 =split(/\./,$shapeit);
	#$shapeit1[0]=~ s/\[\]//g;
	print "JOB ID $shapeit1[0]\n";
	$job_id_shapeit = $shapeit1[0];
}
#making the array job to wait
open(ARRAY_SHAPEIT,">$dirtemp/$rounded/ArrayJob_post_wait.csh") or die "unable to create the array job wait file shape it \n";
if(uc($pbs) ne "YES")
{
	$com = '#!';
	print ARRAY_SHAPEIT "$com $SH\n";
	$com = '#$';
	print ARRAY_SHAPEIT "$com -q $shapeit_queue\n";
	print ARRAY_SHAPEIT "$com -l h_vmem=$shapeit_mem\n";
	print ARRAY_SHAPEIT "$com -M $email\n";
	print ARRAY_SHAPEIT "$com -m a\n";
	print ARRAY_SHAPEIT "$com -V\n";
	print ARRAY_SHAPEIT "$com -cwd\n";
	print ARRAY_SHAPEIT "$com -e $dirtemp/$rounded/\n";
	print ARRAY_SHAPEIT "$com -o $dirtemp/$rounded/\n";
	print ARRAY_SHAPEIT "cp $dirtemp/$rounded/jobid_shapeit $dirtemp/$rounded/waiting.txt\n";
	$sys = "$QSUB -hold_jid $job_id_shapeit $dirtemp/$rounded/ArrayJob_post_wait.csh\n";
	print $sys."\n";
	system($sys);	
}
else
{
	$com = '#!';
	print ARRAY_SHAPEIT "$com $SH\n";
	$com = '#PBS';
	for($p=0;$p<@pbs_param;$p++)
	{
		print ARRAY_SHAPEIT "$com $pbs_param[$p]\n";
	}
	#print ARRAY_SHAPEIT "$com -l walltime=01:05:00\n";
	#print ARRAY_SHAPEIT "$com -l nodes=1:ppn=1\n"; 
	print ARRAY_SHAPEIT "$com -M $email\n";
	print ARRAY_SHAPEIT "$com -m a\n";
	#print ARRAY_SHAPEIT "$com -A normal\n";
	print ARRAY_SHAPEIT "$com -V\n";
	#print ARRAY_SHAPEIT "$com -A bf0\n";
	print ARRAY_SHAPEIT "$com -e $dirtemp/$rounded/\n";
	print ARRAY_SHAPEIT "$com -o $dirtemp/$rounded/\n";
	print ARRAY_SHAPEIT "cp $dirtemp/$rounded/jobid_shapeit $dirtemp/$rounded/waiting.txt\n";
	$sys = "$QSUB -W depend=afterokarray:$job_id_shapeit $dirtemp/$rounded/ArrayJob_post_wait.csh\n";
	print $sys."\n";
	system($sys);

}
$flag = 1;
while($flag > 0)
{
	#print "in the loop\n";
	if($flag%1000000000 == 0)
		{
				$flag = 1;
				print "waiting for the shapeit array job to complete\n";
		}
	$flag++;

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
$k=0;
for($chr=0;$chr<@check_chr;$chr++)
{
	$prevchr=$check_chr[$chr];
	if(!((-e "$dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob.gz" ) && (-e "$dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob_ambi_out.gz") && (-e "$dirtemp/$rounded/$prevchr/beagle_r2.gz") && (-e "$dirtemp/$rounded/$prevchr/Combined_impute_results_3_prob_ind.gz") && (-e "$dirtemp/$rounded/$prevchr/final.dosage.gz")))
	{	
		$k=1;
		print "some thing wrong with post processing chromosome $prevchr\n"; 
	}
}		

if($k ==1)
{
	die "Errors in the post processing(merging the imputation results) steps\n";
}
else
{
	system("mkdir $dirtemp/$rounded/SHAPEIT_OUTPUT");
	system("mv $dirtemp/$rounded/shapeit_jobs.tar.gz $dirtemp/$rounded/SHAPEIT_OUTPUT");
	system("rm $dirtemp/$rounded/post_logfiles_sungrid/*");
	system("rm $dirtemp/$rounded/*");
	system("rmdir rm $dirtemp/$rounded/post_logfiles_sungrid");
	for($chr=0;$chr<@check_chr;$chr++)
	{
		$prevchr=$check_chr[$chr];
		system("rm $dirtemp/$rounded/$prevchr/FILE_POST_SUBMIT.sh");
		system("rm $dirtemp/$rounded/$prevchr/*snps_chr*.*");
	}	
}
