#!/usr/bin/perl
use Getopt::Std;
getopt("a:i:r:o:c:m", \%args);
$ambi = $args{a};
chomp $ambi;
$r2 = $args{r};
chomp $r2;
$input = $args{i};
chomp $input;
$dos_out = $args{o};
chomp $dos_out; 
$chr = $args{c};
chomp $chr; 
$map = $args{m};
chomp $map; 

if($ambi eq "")
{
        die "entered ambi $ambi snps file name  is empty\n";
}
if($r2 eq "")
{
        die "entered  r2 file $r2  is empty\n";
}
if($input eq "")
{
        die "entered  input $input  is empty\n";
}
if($dos_out eq "")
{
        die "entered  dosage output $dos_out  is empty\n";
}
if($chr eq "")
{
        die "entered chromosome $chr  is empty\n";
}
if($map eq "")
{
        die "entered  map file $map is empty\n";
}
if(!(-e $ambi))
{
	die "$ambi file not exists\n";
}
open(AMBI,"gunzip -c $ambi|") or die "no file found $ambi\n";

open R2,"gunzip -c $r2|" or die "no file found $r2 file\n";
if(!(-e $input))
{
	die "$input file not exists\n";
}
$grep = "gunzip -c $input|grep -P '^".$chr." ' |";
open(INPUT,"$grep") or die "no file found $input\n";
open(WRDOS,"|gzip > $dos_out") or die "not able to write dos out $dos_out file\n";
open(WRMAP,"|gzip > $map") or die "not able to write map file $map file\n";
$line = <AMBI>;
$r2="r2";
#intial reading
$line = <AMBI>;
chomp($line);
@array = split(" ",$line);
$pos = shift(@array);
$snp_id = shift(@array);
        #print $snp_id;
$a1 = shift(@array);
$a2 = shift(@array);
print WRMAP "$chr $snp_id 0 $pos\n";
print WRDOS "$snp_id $a1 $a2";
for($r=0;$r<@array;$r++)
{
	print WRDOS " ".$array[$r++]." ".$array[$r++];
}
print WRDOS "\n";
if($r2 eq "r2")
{
    $dos = "";
    $dos_num = @array/3;
    for($i=0;$i<$dos_num;$i++)
    {
		$dos = $dos." 1";
    }
}
$r2 = <R2>;
chomp($r2);
@r2 = split("\t",$r2);
#die "$pos $snp_id $r2[4] $dos\n";
while(<INPUT>)
{
	chomp($_);
	@tped = split(" ",$_);
	shift(@tped);
	$rsid_tped = shift(@tped);
	shift(@tped);
	$pos_tped = shift(@tped);
	#print "$rsid_tped\t$pos_tped\n";
	#reading dosage file
	while($pos_tped ne $pos)
	{
		print "$snp_id $r2[4]$dos\n";
		#reading dosage file
		$line = <AMBI>;
		chomp($line);
		@array = split(" ",$line);
		$pos = shift(@array);
		$snp_id = shift(@array);
		#print $snp_id;
		$a1 = shift(@array);
		$a2 = shift(@array);
		print WRMAP "$chr $snp_id 0 $pos\n";
		print WRDOS "$snp_id $a1 $a2";
		for($r=0;$r<@array;$r++)
		{
			print WRDOS " ".$array[$r++]." ".$array[$r++];
		}
		print WRDOS "\n";
		if($r2 eq "r2")
		{
			$dos = "";
			$dos_num = @array/3;
			for($i=0;$i<$dos_num;$i++)
			{
				$dos = $dos." 1";
			}
		}
		$r2 = <R2>;
		chomp($r2);
		@r2 = split("\t",$r2);
	}
	print "$snp_id $r2[4]";
	for($i=0;$i<@tped;$i++)
	{
		$temp = $tped[$i++]." ".$tped[$i];
		if($temp eq "0 0")
		{
			print " 1";
		}
		else
		{
			print " 0";
		}
	}
	print "\n";
	#die "$line\n";
	#update the reference(increment 1)
	$line = <AMBI>;
	#print "$line\n";
        chomp($line);
        @array = split(" ",$line);
        $pos = shift(@array);
        $snp_id = shift(@array);
        #print $snp_id;
        $a1 = shift(@array);
		$a2 = shift(@array);
		print WRMAP "$chr $snp_id 0 $pos\n";
		print WRDOS "$snp_id $a1 $a2";
		for($r=0;$r<@array;$r++)
		{
			print WRDOS " ".$array[$r++]." ".$array[$r++];
		}
		print WRDOS "\n";
		$r2 = <R2>;
        chomp($r2);
        @r2 = split("\t",$r2);

}
# remaining in the reference
while($line = <AMBI>)
{
		print "$snp_id $r2[4]$dos\n";
		chomp($line);
		@array = split(" ",$line);
		$pos = shift(@array);
		$snp_id = shift(@array);
		#print $snp_id;
		$a1 = shift(@array);
		$a2 = shift(@array);
		print WRMAP "$chr $snp_id 0 $pos\n";
		print WRDOS "$snp_id $a1 $a2";
		for($r=0;$r<@array;$r++)
		{
			print WRDOS " ".$array[$r++]." ".$array[$r++];
		}
		print WRDOS "\n";
		$r2 = <R2>;
		chomp($r2);
		@r2 = split("\t",$r2);
}
print "$snp_id $r2[4]$dos\n";
