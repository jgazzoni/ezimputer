#!/usr/bin/perl
use Getopt::Std;
getopt("i:d:v:o", \%args);
my $infile = $args{i};
my $infilesex = $args{d};
my $outfile = $args{o};
my $mind = $args{v};
chomp($infile);
chomp($outfile);
chomp($mind);
#print $infile."\n";
open BUFF,"< $infilesex"  or die "cannot open infilesex $infilesex";
open BUFF1,"< $infile" or die "cannot open infile $infile";
open(WBUFF,">$outfile");
$line = <BUFF1>;
$line = <BUFF>;
while($line=<BUFF>)
{
	chomp($line);
	$line =~ s/\s+/ /g;
	@array = split(" ",$line);
	if($array[3] eq "0")
	{
		$hash{$array[1]} = "0\t$array[5]";
	}
	elsif($array[2] eq $array[3])
	{
		$hash{$array[1]} = "1\t$array[5]";
	}
	elsif($array[2] ne "1" && $array[2] ne "2")
	{
		$hash{$array[1]} = "2\t$array[5]";
	}
	else
	{
		$hash{$array[1]} = "3\t$array[5]";
	}
	
}
$mind = $mind/2;
print WBUFF "SampleID\tFLAG\tMISSING_GENO_CLEAN\tNUM_GENO_CLEAN\tQC_SAMPLE_FLAG\tQC_SAMPLE_IND\tQC_SEX_IND\tPLINK_SEX_IMP_ESTIMATE\n"; 
while($line = <BUFF1>)
{
        chomp($line);
        $line =~ s/\s+/ /g;
        @array = split(" ",$line);
	#$mind = $mind/2;
	$fac = $array[3]/$array[4];
	if($fac > $mind)
	{
		$k = 0;
	}
	else
	{
		$k = 1;
	}
	#print "$mind\t$fac\n";
        if(exists($hash{$array[1]}))
	{
		print WBUFF $array[1]."\t"."Y\t".$array[3]."\t".$array[4]."\t"."1\t"."$k\t".$hash{$array[1]}."\n";
        }
	else
	{
		print WBUFF $array[1]."\t"."N\t".$array[3]."\t".$array[4]."\t"."0\t"."0\t"."NA\t"."NA\n";
	}
}

close(WBUFF);




if (-e $outfile)
{
	my $debugVar = `ls -ltr $outfile`;
	print "Info: sexcheck.pl: generated output file: $debugVar";
}
else 
{
	print "Error: sexcheck.pl did not create output file $outfile";
	exit(-1);
}
