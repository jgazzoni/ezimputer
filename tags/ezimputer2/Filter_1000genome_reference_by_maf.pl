#####################################################################################################################################################
#Purpose: To recreate the new 1000 genome reference with maf based filtering (Parallel version per chr)
#Date: 11-09-2012
#####################################################################################################################################################
#!/usr/bin/perl
use Getopt::Long;


#get current directory
use Cwd 'abs_path';
$line = abs_path($0);
chomp $line;
@DR_array = split('/',$line);
pop(@DR_array);
$dir = join("/",@DR_array);


&Getopt::Long::GetOptions(
'LMAF=s' => \$lmaf,
'UMAF=s' => \$umaf,
'POPULATION=s' => \$pop,
'REF_GENOME_DIR=s' => \$refdir,
'OUTPUT_DIR=s' => \$outdir,
'INCLUDE_POP=s'=> \$include_pop,
'INCHR=s'=> \$inchr
);
if($include_pop eq ""  || $refdir eq "" || $outdir eq "" )
{
	die "missing arguments\n USAGE : perl Filter_1000genome_reference_by_maf.pl  -INCLUDE_POP <POPULATIONS TO BE INCLUDE IN THE NEW REFERENCE>  -REF_GENOME_DIR <Reference Genome Directory or Path to Metainfo file> -OUTPUT_DIR <OUTPUT DIR>  -LMAF <Lower limit of minor allele frequency for each population (optional)> -UMAF <Upper limit of minor allele frequency for each population (optional)> -POPULATION <Filtering by different population : AFR,AMR,ASN,EUR (optional)> -INCHR <CHROMOSOME TO BE PROCESSED optional>\n";
}
@include_pop=split(',',$include_pop);
if($pop eq "")
{
	$pop=$include_pop[0];	
	$lmaf="0";
	$umaf="1";
	for($i=1;$i<@include_pop;$i++)
	{
		$pop=$pop.','.$include_pop[$i];	
		$lmaf=$lmaf.','."0";
		$umaf=$umaf.','."1";
	}
}
@pop=split(',',$pop);
@lmaf=split(',',$lmaf);
@umaf=split(',',$umaf);
#die "@pop\n@lmaf\n@umaf\n";
#checking for equal number of popultion & maf
if(@pop != @lmaf || @pop != @umaf)
{
	die "number of populations doesn't match with number of lmaf and umaf values\n";
}
 for($i=0;$i<@pop;$i++)
 {
	$pop{uc($pop[$i])}="";
 } 
  for($i=0;$i<@include_pop;$i++)
 {
	$include_pop{uc($include_pop[$i])}="";
	$pop{uc($include_pop[$i])}="";
 }
print "***********INPUT ARGUMENTS***********\n";
print "LMAF : $lmaf\n";
print "UMAF : $umaf\n";
print "POPULATION : @pop\n";
print "REF_GENOME_DIR: $refdir\n";
print "INCLUDE_POP : $include_pop\n";
print "OUTPUT_DIR : $outdir\n";
if(!(-d $refdir) && !(-f $refdir))
{
    print "Directory doesn't exist $reffile_dir\n";
}
$refdir =~ s/\/$//g;

#reading ref directory
require "$dir/bin/Read_reffile.pl";

getRef($refdir);

#check reference
for(my $chr=23;$chr>0;$chr--)
{
	if(exists($ref_meta{"chr$chr".'_'."genetic"}))
	{
		print "chr$chr".'_'."genetic"." ".$ref_meta{"chr$chr".'_'."genetic"}."\n";
	}
	else
	{
		die "there is a problem in the ref dir or metainfo file provided. No value for chr$chr".'_'."genetic\n";
	}
	if(exists($ref_meta{"chr$chr".'_'."hap"}))
	{
			print "chr$chr".'_'."hap"." ".$ref_meta{"chr$chr".'_'."hap"}."\n";
	}
	else
	{
			die "there is a problem in the ref dir or metainfo file provided. No value for chr$chr".'_'."hap\n";
	}
	if(exists($ref_meta{"chr$chr".'_'."legend"}))
	{
			print "chr$chr".'_'."legend"." ".$ref_meta{"chr$chr".'_'."legend"}."\n";
	}
	else
	{
			die "there is a problem in the ref dir or metainfo file provided. No value for chr$chr".'_'."legend\n";
	}
}
if(exists($ref_meta{"sample"}))
{
	print "sample"." ".$ref_meta{"sample"}."\n";
}
else
{
    die "there is a problem in the ref dir or metainfo file provided. No value for sample\n";
}

$outdir =~ s/\/$//g;
#creating output directory if not exists
mkdir "$outdir", unless -d "$outdir";

#opening the sample in the impute 1000 genome reference and extracting the columns for population and group
$file="$reffile_dir/".$ref_meta{"sample"};
open(SAMP,"$refdir/$file") or die "no sample file found $file\n";
if(!(-e "$outdir/$ref_meta{'sample'}"))
{
	open(WRSAMP,">$outdir/$ref_meta{'sample'}") or die "no sample file found $outdir/$ref_meta{'sample'}\n";
}
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
	#print WRSAMP $_;
	chomp($_);
	
	
	@samp=split(" ",$_);
	$samp1_a1=$samp_order++;
	$samp1_a2=$samp_order++;
	if(exists($include_pop{"ALL"}) || exists($include_pop{uc($samp[$samp_pop])})  || exists($include_pop{uc($samp[$samp_group])}))
	{
			print WRSAMP $_."\n";
	}
	if(exists($pop{uc($samp[$samp_pop])}))
	{
		$pop{uc($samp[$samp_pop])}=$pop{uc($samp[$samp_pop])}." $samp1_a1 $samp1_a2";
		
	}
	
	if(exists($pop{uc($samp[$samp_group])}))
	{
		$pop{uc($samp[$samp_group])}=$pop{uc($samp[$samp_group])}." $samp1_a1 $samp1_a2";
	}
	
	if(exists($pop{"ALL"}))
	{
		$pop{"ALL"}=$pop{"ALL"}." $samp1_a1 $samp1_a2";
	}
	
}
close(SAMP);
#die "test ".$pop{"ALL"}."\n";
@final_combined=();
#combining the population for final printing
for($i=0;$i<@include_pop;$i++)
{
	@temp = split(" ",$pop{uc($include_pop[$i])});
	@final_combined=uniq(@final_combined,@temp);
}
@final_combined = sort {$a <=> $b} @final_combined;
#die "@final_combined\n";
#die "$samp_pop hi $samp_group".$pop{"EUR"}."\n";
#for($chr=1;$chr<24;$chr++)
$startchr=$inchr;
if(!defined($inchr))
{
	$startchr=1;
	$inchr=23;	
}
for($chr=$startchr;$chr<=$inchr;$chr++)
{
	print "dealing with chr $chr\n";
	$file="$refdir/".$ref_meta{"chr$chr".'_'."hap"};
	open(HAP,"gunzip -c $file|") or die " no file found ".$file." \n";
	$file="$refdir/".$ref_meta{"chr$chr".'_'."legend"};
	open(LEGEND,"gunzip -c $file|") or die " no file found ".$file." \n";
	$file="$refdir/".$ref_meta{"chr$chr".'_'."genetic"};
	open(GEN,$file) or die " no file found ".$file." \n";
	$basename_hap=`basename $ref_meta{"chr$chr".'_'."hap"}`;
	$basename_legend=`basename $ref_meta{"chr$chr".'_'."legend"}`;
	$basename_genetic=`basename $ref_meta{"chr$chr".'_'."genetic"}`;
	chomp($basename_hap);
	chomp($basename_legend);
	chomp($basename_genetic);
	$file=$basename_legend;
	open(WRLEGEND,"| gzip -c > $outdir/$file") or die "unable to write $file\n";
	$file=$basename_hap;
	open(WRHAP,"| gzip -c > $outdir/$file") or die "unable to write $file\n";
	$file=$basename_genetic;
	open(WRGEN,">$outdir/$file") or die "unable to write $file\n";
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
		for($p=0;$p<@pop&& $k<1;$p++)
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
			#print "$pop[$p] $tmp_maf $lmaf[$p] $umaf[$p]\n";
			#checkign calculated maf with mentioned maf values
			if(!($tmp_maf <= $umaf[$p] && $tmp_maf >= $lmaf[$p]))
			{
					$k=1;
			}
		}
		
		#if k value is unchanged then the input maf conditions are agreed	
		if($k==0)
		{
			$selected{$array[1]} =1;
			my @write_haps;
			for($i=0;$i<@final_combined;$i++)
			{
				$write_haps[$i] = $haps[$final_combined[$i]];
			}
			$haps=join(" ",@write_haps);
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
			delete($selected{$gen[0]});
		}
	}
}
close(GEN);
close(HAP);
close(LEGEND);
close(WRGEN);
close(WRHAP);
close(WRLEGEND);
#########################SUBROUTINES####################################################
sub uniq {
    my %seen;
    grep { !$seen{$_}++ } @_;
}
