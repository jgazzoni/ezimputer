#####################################################################################################################################################
#Purpose: To recreate the new 1000 genome reference with maf base filtering
#Date: 11-09-2012
#####################################################################################################################################################

use Getopt::Long;

&Getopt::Long::GetOptions(
'LMAF=s' => \$lmaf,
'UMAF=s' => \$umaf,
'POPULATION=s' => \$pop,
'REF_GENOME_DIR=s' => \$refdir,
'IMPUTEREF_VERSION=s'=> \$ref_keyword,
'OUTPUT_DIR=s' => \$outdir
);
if($pop eq "" || $umaf eq "" || $lmaf eq "" || $refdir eq "" || $outdir eq "" || $ref_keyword eq "")
{
	die "missing arguments\n USAGE : perl Filter_1000genome_reference_by_maf.pl  -POPULATION <Different population : afr,amr,asn,eur> -LMAF <Lower Limit Minor allele frequency> -UMAF <Upper Limit Minor allele frequency>  -REF_GENOME_DIR <Reference Genome Directory> -OUTPUT_DIR <OUTPUT DIR> -IMPUTEREF_VERSION <version of the impute reference files ex:ALL_1000G_phase1integrated_v3>\n";
}
@pop=split(',',$pop);
@lmaf=split(',',$lmaf);
@umaf=split(',',$umaf);
#checking for equal number of popultion & maf
if(@pop != @lmaf || @pop != @umaf)
{
	die "number of populations doesn't match with number of lmaf and umaf values\n";
}
 for($i=0;$i<@pop;$i++)
 {
	$pop{uc($pop[$i])}="";
 } 
print "***********INPUT ARGUMENTS***********\n";
print "LMAF : $lmaf\n";
print "UMAF : $umaf\n";
print "POPULATION : @pop\n";
print "REF_GENOME_DIR: $refdir\n";
print "IMPUTEREF_VERSION : $ref_keyword\n";
print "OUTPUT_DIR : $outdir\n";
unless(-d $refdir)
{
    print "Directory doesn't exist $refdir\n";
}
$refdir =~ s/\/$//g;
$outdir =~ s/\/$//g;
#creating output directory if not exists
mkdir "$outdir", unless -d "$outdir";

#opening the sample in the impute 1000 genome reference and extracting the columns for population and group
$file_samp=$ref_keyword.".sample";
open(SAMP,"$refdir/$file_samp") or die "no sample file found $file_samp\n";
open(WRSAMP,">$outdir/$file_samp") or die "no sample file found $file_samp\n";
$samp=<SAMP>;
print WRSAMP $samp; 
#print $samp."\n";
@samp=split(" ",$samp);
for($i=0;$i<@samp;$i++)
{
	if(lc($samp[$i]) eq "population")
	{
		$samp_pop=$i;
	}
	if(lc($samp[$i]) eq "group")
	{
		$samp_group=$i;
	}
}

#creating the hash for each population with individuals in it
$samp_order=0;
while(<SAMP>)
{
	print WRSAMP $_;
	chomp($_);
	@samp=split(" ",$_);
	$samp1_a1=$samp_order++;
	$samp1_a2=$samp_order++;
	if(exists($pop{uc($samp[$samp_pop])}))
	{
		$pop{uc($samp[$samp_pop])}=$pop{uc($samp[$samp_pop])}." $samp1_a1 $samp1_a2";
	}
	if(exists($pop{uc($samp[$samp_group])}))
	{
		$pop{uc($samp[$samp_group])}=$pop{uc($samp[$samp_group])}." $samp1_a1 $samp1_a2";
	}
}
close(SAMP);
for($chr=1;$chr<24;$chr++)
{
	print "dealing with chr $chr\n";
	#opening the ref directory files
	if($chr != 23)
	{
		$file= $ref_keyword."_chr".$chr."_impute.legend.gz";
		open(LEGEND,"gunzip -c $refdir/$file |") or die " no file found $file \n";
		open(WRLEGEND,"| gzip -c > $outdir/$file") or die "unable to write $file\n";
		$file= $ref_keyword."_chr".$chr."_impute.hap.gz";
		open(HAP,"gunzip -c $refdir/$file |") or die " no file found $file \n";
		open(WRHAP,"| gzip -c > $outdir/$file") or die "unable to write $file\n";
		$file="genetic_map_chr$chr"."_combined_b37.txt";
		open(GEN,"$refdir/$file") or die "no file $file \n";
		open(WRGEN,">$outdir/$file") or die "unable to write $file\n";
	}	
	else
	{
		$file = $ref_keyword."_chrX_nonPAR_impute.legend.gz";
		open(LEGEND,"gunzip -c $refdir/$file |") or die " no file found $file \n";
		open(WRLEGEND,"| gzip -c > $outdir/$file") or die "unable to write $file\n";
		$file= $ref_keyword."_chrX_nonPAR_impute.hap.gz";
		open(HAP,"gunzip -c $refdir/$file |") or die " no file found $file \n";
		open(WRHAP,"| gzip -c > $outdir/$file") or die "unable to write $file\n";
		$file="genetic_map_chrX_nonPAR_combined_b37.txt";
		open(GEN,"$refdir/$file") or die "no file $file \n"; 
		open(WRGEN,">$outdir/$file") or die "unable to write $file\n";
	}
	$line = <LEGEND>;
	print WRLEGEND $line;
	#die "$line\n";
	$line=<GEN>;
	print WRGEN $line;
	#die "$maf\n";
	undef(%pos);
	#reading the legend and haps file from the referece directory
	while(<LEGEND>)
	{
		chomp($_);
		@array=split(" ",$_);
		$haps=<HAP>;
		chomp($haps);
		#print "$chr $array[1]\n";
		@haps=split(" ",$haps);
		$k=0;	
		@tmp_pop=();
		#parsing through the each of the chromosome
		for($p=0;$p<@pop;$p++)
		{
			$key=$pop[$p];
			$value=$pop{uc($key)};
			$tmp_pop ="";
			$tmp_maf="";
			undef(@tmp_pop);
			@tmp_pop=split(" ",$value);
			for($i=0;$i<@tmp_pop;$i++)
			{
				$tmp_pop =$tmp_pop." ".$haps[$tmp_pop[$i]];
			}
			#counting different alleles
			$tmp_pop_0 = ()=$tmp_pop=~ m/ 0/g;
			$tmp_pop_1 = ()=$tmp_pop=~ m/ 1/g;
			#calculating the maf
			if($tmp_pop_0 > $tmp_pop_1)
			{
					$tmp_maf=$tmp_pop_1/($tmp_pop_1 + $tmp_pop_0);
			}
			else
			{
				$tmp_maf=$tmp_pop_0/($tmp_pop_1 + $tmp_pop_0);
			}
			#checkign calculated maf with mentioned maf values
			if(!($tmp_maf < $umaf[$p] && $tmp_maf > $lmaf[$p]))
			{
					$k=1;
			}
		}
		#if k value is unchanged then the input maf conditions are agreed	
		if($k==0)
		{
			$selected{$array[1]} =1;
			print WRLEGEND "$_\n";
			print WRHAP "$haps\n";
		}	
	}
	#creating the new genetic map file with only markers satisfying the maf condition
	while(<GEN>)
	{
		chomp($_);
		@gen=split(" ",$_);
		if(exists($selected{$gen[0]}))
		{
			print WRGEN $_."\n";
		}
	}
}
close(GEN);
close(HAP);
close(LEGEND);
close(WRGEN);
close(WRHAP);
close(WRLEGEND);
