$infile=$ARGV[0];
chomp($infile);
$outfile_regained=$ARGV[1];
$outfile_report=$ARGV[2];
chomp($outfile_regained);
chomp($outfile_report);
open(BUFF,$infile) or die "no input file found $infile\n";
open(WREX,">$outfile_regained") or die "not able to write the file $outfile_regained\n";
open(WRREP,">$outfile_report") or die "not  able to write the file $outfile_report\n";
$header=<BUFF>;
print WRREP $header;
while(<BUFF>)
{
	chomp($_);	
	@a=split("\t",$_);
	if($a[0] =~ m/^strand/ && $a[3] eq "0" &&( $a[4] eq $a[6] || $a[4] eq $a[7] ))
	{
		print WREX $_."\n";
	}
	else
	{
		print WRREP $_."\n";
	}
}	
close(WREX);
close(WRREP);
