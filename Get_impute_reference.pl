#####################################################################################################################################################
#Purpose: To download impute reference files
#Date: 01-08-2013
#####################################################################################################################################################
use Getopt::Long;
#reading input arguments
&Getopt::Long::GetOptions(
'OUT_REF_DIR=s'=> \$outdir,
'DOWNLOAD_LINK=s' => \$downloadlink,
);
$outdir =~ s/\s|\t|\r|\n//g;
$downloadlink=~ s/\s|\t|\r|\n//g;

#input arguments
#$outdir="/data4/bsi/RandD/Workflow/temp/v3/";
#$downloadlink="http://mathgen.stats.ox.ac.uk/impute/ALL_1000G_phase1integrated_v3_impute.tgz";

#checking for missing arguments
if($outdir eq "" || $downloadlink eq "" )
{
	die "missing arguments\n USAGE : perl Get_impute_reference.pl -OUT_REF_DIR <TARGET IMPUTE REFERENCE DIRECTORY> -DOWNLOAD_LINK <DOWNLOAD LINK>\n";
}

#parsing the arguments
$outdir=~ s/\/$//g;
unless(-d $outdir)
{
	system("mkdir -p $outdir");
}
chdir($outdir);
@download=split(/\//,$downloadlink);
$file=pop(@download);
@files=split(/\./,$file);
@keywords=split('_',$file);
pop(@keywords);
$keyword=join("_",@keywords);
#die "$keyword\n";
#download the reference files
system("wget $downloadlink");

#checking if the file exists
if(!(-e $file))
{
	die "file $file not downloaded sucessfully.Check for the Download link\n";
}
#untar and gunzip the reference files
system("tar -zxvf $file");
$output_impute="$outdir/$files[0]";
print "NOTEDOWN BELOW DETAILS FOR FUTURE USE\n";
print "IMPUTE REF DIRECTORY : $output_impute\n";
print "IMPUTE REF KEYWORD : $keyword\n";
