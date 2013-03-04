#####################################################################################################################################################
#Purpose: To upgrade build 36 positions to build 37 positions 
#Date: 11-09-2012
#inputfile : build36 tped file
#outputfile: new build37 tped file & left over build 36 tped file
#####################################################################################################################################################
use Getopt::Long;
#reading input arguments
&Getopt::Long::GetOptions(
'DBSNP_DOWNLOADLINK=s' => \$dbsnp_ver,
'DBSNP_DIR=s' => \$dbsnp_dir,
'INPUT_FILE=s' => \$inputfile,
'OUTPUTFILE_BUILD37=s'=> \$outputfile_37,
'OUTPUTFILE_BUILD36=s' => \$outputfile_36,
);
chomp($inputfile);
chomp($dbsnp_ver);
chomp($dbsnp_dir);
$dbsnp_dir =~ s/\/$//g;
chomp($outputfile_37);
chomp($outputfile_36);

$inputfile =~ s/\s|\t|\r|\n//g;
$dbsnp_ver =~ s/\s|\t|\r|\n//g;
$dbsnp_dir =~ s/\s|\t|\r|\n//g;
$outputfile_37 =~ s/\s|\t|\r|\n//g;
$outputfile_36 =~ s/\s|\t|\r|\n//g;
#checking for missing arguments
if( $dbsnp_dir eq "" || $dbsnp_ver eq "" || $inputfile eq "" || $outputfile_37 eq "" || $outputfile_36 eq "")
{
	die "missing arguments\n USAGE : perl Upgrade_inputmarkers_to_build37_by_DBSNP.pl  -DBSNP_DIR <DBSNP DIR> -DBSNP_DOWNLOADLINK <DBSNP VERSION>  -INPUT_FILE <INPUT TPED FILE> -OUTPUTFILE_BUILD37 <OUTPUT TPED FILE BUILD 37> -OUTPUTFILE_BUILD36 <OUTPUT TPED FILE BUILD 36>\n";
}
print "***********INPUT ARGUMENTS***********\n";
print "DBSNP_DOWNLOAD LINK: $dbsnp_ver\n";
print "INPUT_FILE: $inputfile\n";
print "OUTPUTFILE_BUILD37 : $outputfile_37\n";
print "OUTPUTFILE_BUILD36 : $outputfile_36\n";
print "DBSNP_DIR : $dbsnp_dir\n";
#downloading the dnsnp file 
#$file1="b".$dbsnp_ver."_SNPChrPosOnRef.bcp.gz";
#$file2="RsMergeArch.bcp.gz";
$hyperlink1=$dbsnp_ver;
#for build 137 ftp://ftp.ncbi.nlm.nih.gov/snp/organisms/human_9606/database/organism_data/b137_SNPChrPosOnRef.bcp.gz
#for build 135 ftp://ftp.ncbi.nih.gov/snp/organisms/human_9606/database/b135_archive/organism_data/b135_SNPChrPosOnRef_37_3.bcp.gz

#$hyperlink1="ftp://ftp.ncbi.nlm.nih.gov/snp/organisms/human_9606/database/organism_data/"."b".$dbsnp_ver."_SNPChrPosOnRef.bcp.gz";
#$hyperlink2="ftp://ftp.ncbi.nlm.nih.gov/snp/organisms/human_9606/database/organism_data/$file2";
@hyperlink1 = split(/\//,$hyperlink1);
$file1=pop(@hyperlink1);
unless(-d "$dbsnp_dir")
{
    system("mkdir -p $dbsnp_dir");
}
chdir("$dbsnp_dir/");

if(!(-e $file1))
{
	system("wget $hyperlink1"); 
	$sys="gunzip -c $dbsnp_dir/$file1|awk '{if(NF==4)print \$0}'|gzip > $dbsnp_dir/temp.gz";
	system($sys);
	system("mv $dbsnp_dir/temp.gz $dbsnp_dir/$file1");
}

if(!(-e $file1))
{
	die "$file1 not downloaded properly.Please change the hyperlink in the script $hyperlink1\n";
}
print "Done downloading file $file1\n";
open(BUFF,"$inputfile") or die "no file exists $inputfile\n";
open(WRBUFF1,">$outputfile_37") or die "not able write to $outputfile_37\n";
open(WRBUFF2,">$outputfile_36") or die "not able write to $outputfile_36\n";
my %hash;
#parsing through input tped file and separatin the markers based on the marker ID type (starts with rs)
while(<BUFF>)
{
	#print "$.\n";
	chomp($_);
	$_ =~ s/\t/ /g;
	@a = split(" ",$_);
	if($a[1] =~ m/^rs/)
	{
		$a[1] =~ s/rs//g;
		$_=join(" ",@a);	
		print WRBUFF1 "$_\n";
	}
	else
	{
		print WRBUFF2 "$_\n";
	}
} 
close(BUFF);
close(WRBUFF1);
close(WRBUFF2);
#sorting the build 37 file in order to compare with DB snp
system("sort -k2,2n $outputfile_37 > $outputfile_37.tmp");
system("mv $outputfile_37.tmp $outputfile_37");


#updating the rsid position and chr according to dbsnp (if not found in dbsnp then transfering to build 36 file)
open(BUFF,"$outputfile_37") or die "no file exists $outputfile_37\n";
open(WRBUFF1,">$outputfile_37.tmp") or die " not able to write $outputfile_37.tmp\n";
open(WRBUFF2,">>$outputfile_36") or die " not able to write $outputfile_36.tmp\n";
#die "$dbsnp_dir/$dbsnp_ver/$file1\n";
open(DB,"gunzip -c $dbsnp_dir/$file1 |") or die " no file exists $file1\n";
while($line=<BUFF>)
{
	chomp($line);
	@a=split(" ",$line);
	$db=<DB>;
	chomp($db);
	@db=split("\t",$db);
	while($a[1] > $db[0])
	{
		$db=<DB>;
		if($db !~ m/\w/)
		{
			last;
		}
		chomp($db);
		@db=split("\t",$db);
	}
	while($a[1] < $db[0])
	{
		#$a[1] = "rs$a[1]";
		#$line=join(" ",@a);
		print WRBUFF2 $line."\n";
		$line=<BUFF>;
		if($line !~ m/\w/)
		{
			last;
		}
		@a=split(" ",$line);
	}
	if($a[1] == $db[0])
	{
		$a[0] = $db[1];
		$a[0] =~ s/X/23/g;
		$a[0] =~ s/Y/24/g;
		$a[0] =~ s/MT/26/g;
		if($a[0] =~ m/\d+/)
		{
		#dbsnp position is zero based so increment by 1
		$a[3] = $db[2]+1;
		$a[1] = "rs$a[1]";
		$line=join(" ",@a);
		print WRBUFF1 $line."\n";
		}
		else
		{
			print WRBUFF2 $line."\n";
		}
		#die "success\n";
	}
	else
	{
		#$a[1] = "rs$a[1]";
		#$line=join(" ",@a);
		print WRBUFF2 $line."\n";
	}
}
close(BUFF);
close(WRBUFF1);
close(WRBUFF2);
close(DB);
system("sort -k1,1n -k4,4n  $outputfile_37.tmp >$outputfile_37");
system("rm $outputfile_37.tmp");

print "Update done\n";
